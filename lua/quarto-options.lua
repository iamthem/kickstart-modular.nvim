-- required in which-key plugin spec in plugins/ui.lua as `require 'config.keymap'`
local wk = require 'which-key'
local ms = vim.lsp.protocol.Methods

P = vim.print

local nmap = function(key, effect, desc)
  vim.keymap.set('n', key, effect, { silent = true, noremap = true, desc = desc })
end

local vmap = function(key, effect, desc)
  vim.keymap.set('v', key, effect, { silent = true, noremap = true, desc = desc })
end

local imap = function(key, effect, desc)
  vim.keymap.set('i', key, effect, { silent = true, noremap = true, desc = desc })
end

local cmap = function(key, effect, desc)
  vim.keymap.set('c', key, effect, { silent = true, noremap = true, desc = desc })
end

-- keep selection after indent/dedent
vmap('>', '>gv')
vmap('<', '<gv')

-- center after search and jumps
nmap('n', 'nzz')

local function toggle_light_dark_theme()
  if vim.o.background == 'light' then
    vim.o.background = 'dark'
  else
    vim.o.background = 'light'
  end
end

local is_code_chunk = function()
  local current, _ = require('otter.keeper').get_current_language_context()
  if current then
    return true
  else
    return false
  end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'n', true)
  local keys
  if is_code_chunk() then
    keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
  else
    keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
  end
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', false)
end

local insert_r_chunk = function()
  insert_code_chunk 'r'
end

local insert_py_chunk = function()
  insert_code_chunk 'python'
end

local insert_lua_chunk = function()
  insert_code_chunk 'lua'
end

local insert_julia_chunk = function()
  insert_code_chunk 'julia'
end

local insert_bash_chunk = function()
  insert_code_chunk 'bash'
end

local insert_ojs_chunk = function()
  insert_code_chunk 'ojs'
end

--show kepbindings with whichkey
--add your own here if you want them to
--show up in the popup as well

-- normal mode
wk.add({
  { '<c-LeftMouse>', '<cmd>lua vim.lsp.buf.definition()<CR>', desc = 'go to definition' },
  { '<c-q>', '<cmd>q<cr>', desc = 'close buffer' },
  { '<esc>', '<cmd>noh<cr>', desc = 'remove search highlight' },
  { '<m-I>', insert_py_chunk, desc = 'python code chunk' },
  { '[q', ':silent cprev<cr>', desc = '[q]uickfix prev' },
  { ']q', ':silent cnext<cr>', desc = '[q]uickfix next' },
  { 'gN', 'Nzzzv', desc = 'center search' },
  { 'gf', ':e <cfile><CR>', desc = 'edit file' },
  { 'gl', '<c-]>', desc = 'open help link' },
  { 'n', 'nzzzv', desc = 'center search' },
  { 'z?', ':setlocal spell!<cr>', desc = 'toggle [z]pellcheck' },
  { 'zl', ':Telescope spell_suggest<cr>', desc = '[l]ist spelling suggestions' },
}, { mode = 'n', silent = true })

-- visual mode
wk.add {
  {
    mode = { 'v' },
    { '.', ':norm .<cr>', desc = 'repat last normal mode command' },
    { '<M-j>', ":m'>+<cr>`<my`>mzgv`yo`z", desc = 'move line down' },
    { '<M-k>', ":m'<-2<cr>`>my`<mzgv`yo`z", desc = 'move line up' },
    { 'q', ':norm @q<cr>', desc = 'repat q macro' },
  },
}

-- visual with <leader>
wk.add({
  { '<leader>d', '"_d', desc = 'delete without overwriting reg', mode = 'v' },
  { '<leader>p', '"_dP', desc = 'replace without overwriting reg', mode = 'v' },
}, { mode = 'v' })

-- insert mode
wk.add({
  {
    mode = { 'i' },
    { '<c-x><c-x>', '<c-x><c-o>', desc = 'omnifunc completion' },
    { '<m-->', ' <- ', desc = 'assign' },
    { '<c-i>', insert_py_chunk, desc = 'python code chunk' },
    { '<c-c>', insert_r_chunk, desc = 'r code chunk' },
    { '<m-m>', ' |>', desc = 'pipe' },
  },
}, { mode = 'i' })

local function new_terminal(lang)
  vim.cmd('vsplit term://' .. lang)
end

local function new_terminal_python()
  new_terminal 'python'
end

local function new_terminal_r()
  new_terminal '/home/ubuntu/miniconda3/envs/py3Renv/bin/R --no-save'
end

local function new_terminal_ipython()
  new_terminal '/home/ubuntu/miniconda3/envs/py3Renv/bin/ipython --no-confirm-exit'
end

local function new_terminal_julia()
  new_terminal 'julia'
end

local function new_terminal_shell()
  new_terminal '$SHELL'
end

local function get_otter_symbols_lang()
  local otterkeeper = require 'otter.keeper'
  local main_nr = vim.api.nvim_get_current_buf()
  local langs = {}
  for i, l in ipairs(otterkeeper.rafts[main_nr].languages) do
    langs[i] = i .. ': ' .. l
  end
  -- promt to choose one of langs
  local i = vim.fn.inputlist(langs)
  local lang = otterkeeper.rafts[main_nr].languages[i]
  local params = {
    textDocument = vim.lsp.util.make_text_document_params(),
    otter = {
      lang = lang,
    },
  }
  -- don't pass a handler, as we want otter to use it's own handlers
  vim.lsp.buf_request(main_nr, ms.textDocument_documentSymbol, params, nil)
end

vim.keymap.set('n', '<leader>os', get_otter_symbols_lang, { desc = 'otter [s]ymbols' })

local function toggle_conceal()
  local lvl = vim.o.conceallevel
  if lvl > DefaultConcealLevel then
    vim.o.conceallevel = DefaultConcealLevel
  else
    vim.o.conceallevel = FullConcealLevel
  end
end

require('jupytext').setup {
  style = 'markdown',
  output_extension = 'md',
  force_ft = 'markdown',
}
-- automatically import output chunks from a jupyter notebook
-- tries to find a kernel that matches the kernel in the jupyter notebook
-- falls back to a kernel that matches the name of the active venv (if any)
local imb = function(e) -- init molten buffer
  vim.schedule(function()
    local kernels = vim.fn.MoltenAvailableKernels()
    local try_kernel_name = function()
      local metadata = vim.json.decode(io.open(e.file, 'r'):read 'a')['metadata']
      return metadata.kernelspec.name
    end
    local ok, kernel_name = pcall(try_kernel_name)
    if not ok or not vim.tbl_contains(kernels, kernel_name) then
      kernel_name = nil
      local venv = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX'
      if venv ~= nil then
        kernel_name = string.match(venv, '/.+/(.+)')
      end
    end
    if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
      vim.cmd(('MoltenInit %s'):format(kernel_name))
    end
    vim.cmd 'MoltenImportOutput'
  end)
end

-- automatically import output chunks from a jupyter notebook
vim.api.nvim_create_autocmd('BufAdd', {
  pattern = { '*.ipynb' },
  callback = imb,
})

-- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.ipynb' },
  callback = function(e)
    if vim.api.nvim_get_vvar 'vim_did_enter' ~= 1 then
      imb(e)
    end
  end,
})

-- automatically export output chunks to a jupyter notebook on write
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.ipynb' },
  callback = function()
    if require('molten.status').initialized() == 'Molten' then
      vim.cmd 'MoltenExportOutput!'
    end
  end,
})

-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

local function new_notebook(filename)
  local path = filename .. '.ipynb'
  local file = io.open(path, 'w')
  if file then
    file:write(default_notebook)
    file:close()
    vim.cmd('edit ' .. path)
  else
    print 'Error: Could not open new notebook file for writing.'
  end
end

vim.api.nvim_create_user_command('NewNotebook', function(opts)
  new_notebook(opts.args)
end, {
  nargs = 1,
  complete = 'file',
})

-- eval "$(tmux showenv -s DISPLAY)"
-- normal mode with <leader>
wk.add({
  {
    { '<leader>c', group = '[c]ode / [c]ell / [c]hunk' },
    { '<leader>ci', new_terminal_ipython, desc = 'new [i]python terminal' },
    { '<leader>cj', new_terminal_julia, desc = 'new [j]ulia terminal' },
    { '<leader>cn', new_terminal_shell, desc = '[n]ew terminal with shell' },
    { '<leader>cp', new_terminal_python, desc = 'new [p]ython terminal' },
    { '<leader>cr', new_terminal_r, desc = 'new [R] terminal' },
    { '<leader>d', group = '[d]ebug' },
    { '<leader>dt', group = '[t]est' },
    { '<leader>e', group = '[e]dit' },
    { '<leader>e', group = '[t]mux' },
    { '<leader>fd', [[eval "$(tmux showenv -s DISPLAY)"]], desc = '[d]isplay fix' },
    { '<leader>f', group = '[f]ind (telescope)' },
    { '<leader>f<space>', '<cmd>Telescope buffers<cr>', desc = '[ ] buffers' },
    { '<leader>fM', '<cmd>Telescope man_pages<cr>', desc = '[M]an pages' },
    { '<leader>fb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = '[b]uffer fuzzy find' },
    { '<leader>fc', '<cmd>Telescope git_commits<cr>', desc = 'git [c]ommits' },
    { '<leader>fd', '<cmd>Telescope buffers<cr>', desc = '[d] buffers' },
    { '<leader>ff', '<cmd>Telescope find_files<cr>', desc = '[f]iles' },
    { '<leader>fg', '<cmd>Telescope live_grep<cr>', desc = '[g]rep' },
    { '<leader>fh', '<cmd>Telescope help_tags<cr>', desc = '[h]elp' },
    { '<leader>fj', '<cmd>Telescope jumplist<cr>', desc = '[j]umplist' },
    { '<leader>fk', '<cmd>Telescope keymaps<cr>', desc = '[k]eymaps' },
    { '<leader>fl', '<cmd>Telescope loclist<cr>', desc = '[l]oclist' },
    { '<leader>fm', '<cmd>Telescope marks<cr>', desc = '[m]arks' },
    { '<leader>fq', '<cmd>Telescope quickfix<cr>', desc = '[q]uickfix' },
    { '<leader>g', group = '[g]it' },
    { '<leader>gb', group = '[b]lame' },
    { '<leader>gbb', ':GitBlameToggle<cr>', desc = '[b]lame toggle virtual text' },
    { '<leader>gbc', ':GitBlameCopyCommitURL<cr>', desc = '[c]opy' },
    { '<leader>gbo', ':GitBlameOpenCommitURL<cr>', desc = '[o]pen' },
    { '<leader>gc', ':GitConflictRefresh<cr>', desc = '[c]onflict' },
    { '<leader>gd', group = '[d]iff' },
    { '<leader>gdc', ':DiffviewClose<cr>', desc = '[c]lose' },
    { '<leader>gdo', ':DiffviewOpen<cr>', desc = '[o]pen' },
    { '<leader>gs', ':Gitsigns<cr>', desc = 'git [s]igns' },
    {
      '<leader>gwc',
      ":lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
      desc = 'worktree create',
    },
    {
      '<leader>gws',
      ":lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
      desc = 'worktree switch',
    },
    { '<leader>h', group = '[h]elp / [h]ide / debug' },
    { '<leader>hc', group = '[c]onceal' },
    { '<leader>hc', toggle_conceal, desc = '[c]onceal toggle' },
    { '<leader>ht', group = '[t]reesitter' },
    { '<leader>htt', vim.treesitter.inspect_tree, desc = 'show [t]ree' },
    { '<leader>i', group = '[i]mage' },
    { '<localleader>l', group = '[l]anguage/lsp' },
    { '<localleader>la', vim.lsp.buf.code_action, desc = 'code [a]ction' },
    { '<localleader>ld', group = '[d]iagnostics' },
    {
      '<localleader>ldd',
      function()
        vim.diagnostic.enable(false)
      end,
      desc = '[d]isable',
    },
    { '<localleader>lde', vim.diagnostic.enable, desc = '[e]nable' },
    { '<localleader>le', vim.diagnostic.open_float, desc = 'diagnostics (show hover [e]rror)' },
    { '<localleader>lg', ':Neogen<cr>', desc = 'neo[g]en docstring' },
    { '<leader>o', group = '[o]tter & c[o]de' },
    { '<leader>oa', require('otter').activate, desc = 'otter [a]ctivate' },
    { '<leader>ob', insert_bash_chunk, desc = '[b]ash code chunk' },
    { '<leader>oc', 'O# %%<cr>', desc = 'magic [c]omment code chunk # %%' },
    { '<leader>od', require('otter').activate, desc = 'otter [d]eactivate' },
    { '<leader>oj', insert_julia_chunk, desc = '[j]ulia code chunk' },
    { '<leader>ol', insert_lua_chunk, desc = '[l]lua code chunk' },
    { '<leader>oo', insert_ojs_chunk, desc = '[o]bservable js code chunk' },
    { '<leader>op', insert_py_chunk, desc = '[p]ython code chunk' },
    { '<leader>or', insert_r_chunk, desc = '[r] code chunk' },
    { '<leader>q', group = '[q]uarto' },
    {
      '<leader>qE',
      function()
        require('otter').export(true)
      end,
      desc = '[E]xport with overwrite',
    },
    { '<leader>qa', ':QuartoActivate<cr>', desc = '[a]ctivate' },
    { '<leader>qe', require('otter').export, desc = '[e]xport' },
    { '<leader>qh', ':QuartoHelp ', desc = '[h]elp' },
    { '<leader>qp', ":lua require'quarto'.quartoPreview()<cr>", desc = '[p]review' },
    { '<leader>qu', ":lua require'quarto'.quartoUpdatePreview()<cr>", desc = '[u]pdate preview' },
    { '<leader>qq', ":lua require'quarto'.quartoClosePreview()<cr>", desc = '[q]uiet preview' },
    { '<leader>v', group = '[v]im' },
    { '<leader>vc', ':Telescope colorscheme<cr>', desc = '[c]olortheme' },
    { '<leader>vl', ':Lazy<cr>', desc = '[l]azy package manager' },
    { '<leader>vm', ':Mason<cr>', desc = '[m]ason software installer' },
    { '<leader>vs', ':e $MYVIMRC | :cd %:p:h | split . | wincmd k<cr>', desc = '[s]ettings, edit vimrc' },
    { '<leader>vt', toggle_light_dark_theme, desc = '[t]oggle light/dark theme' },
    { '<leader>x', group = 'e[x]ecute' },
    { '<leader>xx', ':w<cr>:source %<cr>', desc = '[x] source %' },
  },
}, { mode = 'n' })
