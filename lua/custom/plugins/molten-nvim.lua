return {
  'benlubas/molten-nvim',
  dependencies = { '3rd/image.nvim' },
  build = ':UpdateRemotePlugins',

  init = function()
    vim.g.molten_image_provider = 'image.nvim'
    -- vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = true
    vim.g.molten_auto_open_html_in_browser = true
    vim.g.molten_tick_rate = 200

    -- optional, I like wrapping. works for virt text and the output window
    vim.g.molten_wrap_output = true
    --
    -- Output as virtual text. Allows outputs to always be shown, works with images, but can
    -- be buggy with longer images
    vim.g.molten_virt_text_output = true
    -- this will make it so the output shows up below the \`\`\` cell delimiter
    vim.g.molten_virt_lines_off_by_1 = true

    vim.g.molten_copy_output = true
  end,

  config = function()
    local init = function()
      local quarto_cfg = require('quarto.config').config
      quarto_cfg.codeRunner.default_method = 'molten'
      vim.cmd [[MoltenInit]]
    end
    local deinit = function()
      vim.cmd [[MoltenDeinit]]
    end
    vim.keymap.set('n', '<localleader>mi', init, { silent = true, desc = 'Initialize molten' })
    vim.keymap.set('n', '<localleader>md', deinit, { silent = true, desc = 'Stop molten' })
    vim.keymap.set('n', '<localleader>mp', ':MoltenImagePopup<CR>', { silent = true, desc = 'molten image popup' })
    vim.keymap.set('n', '<localleader>mb', ':MoltenOpenInBrowser<CR>', { silent = true, desc = 'molten open in browser' })
    vim.keymap.set('n', '<localleader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'hide output' })
    vim.keymap.set('n', '<localleader>mk', ':MoltenInterrupt<CR>', { silent = true, desc = 'interrupt kernel' })
    vim.keymap.set('n', '<localleader>ms', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'show/enter output' })

    vim.keymap.set('n', '<localleader>e', ':MoltenEvaluateOperator<CR>', { desc = 'evaluate operator', silent = true })
    vim.keymap.set('n', '<localleader>rr', ':MoltenReevaluateCell<CR>', { desc = 're-eval cell', silent = true })
    vim.keymap.set('v', '<localleader>r', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'execute visual selection', silent = true })
    vim.keymap.set('n', '<localleader>md', ':MoltenDelete<CR>', { desc = 'delete Molten cell', silent = true })

    local runner = require 'quarto.runner'
    vim.keymap.set('n', '<localleader>rc', runner.run_cell, { desc = 'run cell', silent = true })
    vim.keymap.set('n', '<localleader>ra', runner.run_above, { desc = 'run cell and above', silent = true })
    vim.keymap.set('n', '<localleader>rA', runner.run_all, { desc = 'run all cells', silent = true })
    vim.keymap.set('n', '<localleader>rl', runner.run_line, { desc = 'run line', silent = true })
    vim.keymap.set('v', '<localleader>r', runner.run_range, { desc = 'run visual range', silent = true })
    vim.keymap.set('n', '<localleader>RA', function()
      runner.run_all(true)
    end, { desc = 'run all cells of all languages', silent = true })
  end,
}
