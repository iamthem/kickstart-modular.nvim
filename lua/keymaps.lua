-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have coliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
--
--==================================================
-- Buffer cyclying
--==================================================
-- Map <Tab> to go to the next buffer
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })

-- Map <Shift-Tab> to go to the previous buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- Visual mode: search for selected text using //
vim.keymap.set('v', '//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { noremap = true, silent = true })
-- Normal mode: <leader>/ to clear search highlight
vim.keymap.set('n', '<leader>/', ':noh<CR>', { noremap = true, silent = true })

-- Diff shortcuts
vim.keymap.set('n', 'dfu', ':diffupdate<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'dfp', ':diffput<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'dfg', ':diffget<CR>', { noremap = true, silent = true })

-- In insert mode: <C-e> moves to end of line
vim.keymap.set('i', '<C-e>', '<C-o>$', { noremap = true })

-- In insert mode: <C-a> moves to beginning of line
vim.keymap.set('i', '<C-a>', '<C-o>0', { noremap = true })

-- vim: ts=2 sts=2 sw=2 et
