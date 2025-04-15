return {
  {
    'R-nvim/R.nvim',
    -- Only required if you also set defaults.lazy = true
    lazy = false,
    -- R.nvim is still young and we may make some breaking changes from time
    -- to time (but also bug fixes all the time). If configuration stability
    -- is a high priority for you, pin to the latest minor version, but unpin
    -- it and try the latest version before reporting an issue:
    -- version = "~0.1.0"
    config = function()
      -- Create a table with the options to be passed to setup()
      ---@type RConfigUserOpts
      local opts = {
        hook = {
          on_filetype = function()
            vim.api.nvim_buf_set_keymap(0, 'n', '<Enter>', '<Plug>RDSendLine', {})
            vim.api.nvim_buf_set_keymap(0, 'v', '<Enter>', '<Plug>RSendSelection', {})
            vim.keymap.set('i', 'PP', '%>%', { silent = true, noremap = true, desc = desc })
            vim.keymap.set('i', '--', ' <- ', { silent = true, noremap = true, desc = desc })

            if vim.o.termguicolors then
              vim.g.rout_color_input = 'guifg=#9e9e9e'
              vim.g.rout_color_normal = 'guifg=#ff5f00'
              vim.g.rout_color_number = 'guifg=#ffaf00'
              vim.g.rout_color_integer = 'guifg=#feaf00'
              vim.g.rout_color_float = 'guifg=#fdaf00'
              vim.g.rout_color_complex = 'guifg=#fcaf00'
              vim.g.rout_color_negnum = 'guifg=#d7afff'
              vim.g.rout_color_negfloat = 'guifg=#d6afff'
              vim.g.rout_color_date = 'guifg=#00d7af'
              vim.g.rout_color_true = 'guifg=#5dd685'
              vim.g.rout_color_false = 'guifg=#ff5d5e'
              vim.g.rout_color_inf = 'guifg=#10aed7'
              vim.g.rout_color_constant = 'guifg=#5fafcf'
              vim.g.rout_color_string = 'guifg=#5fd7af'
              vim.g.rout_color_error = 'guifg=#ffffff guibg=#c40000'
              vim.g.rout_color_warn = 'guifg=#d00000'
              vim.g.rout_color_index = 'guifg=#d0d080'
            end
          end,
        },
        R_path = '/home/ubuntu/miniconda3/envs/py3Renv/bin',
        R_args = { '--quiet', '--no-save' },
        min_editor_width = 72,
        rconsole_width = 78,
        objbr_mappings = { -- Object browser keymap
          c = 'class', -- Call R functions
          ['<localleader>ro'] = 'head({object}, n = 15)', -- Use {object} notation to write arbitrary R code.
          v = function()
            -- Run lua functions
            require('r.browser').toggle_view()
          end,
        },
        disable_cmds = {
          'RClearConsole',
          'RCustomStart',
          'RSPlot',
          'RSaveClose',
        },
      }
      -- Check if the environment variable "R_AUTO_START" exists.
      -- If using fish shell, you could put in your config.fish:
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == 'true' then
        opts.auto_start = 'on startup'
        opts.objbr_auto_start = true
      end
      require('r').setup(opts)
    end,
  },

  {
    'R-nvim/cmp-r',
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('cmp').setup { sources = { { name = 'cmp_r' } } }
        require('cmp_r').setup {}
      end,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'markdown', 'markdown_inline', 'r', 'rnoweb', 'yaml', 'latex', 'csv' },
        highlight = { enable = true },
      }
    end,
  },
}
