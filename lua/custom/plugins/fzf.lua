return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},

    config = function()
      local fzf = require 'fzf-lua'

      -- Plugin setup ---------------------------------------------------------
      fzf.setup {
        'border-fused', -- style preset
        fzf_opts = { ['--wrap'] = true },

        previewers = {
          builtin = {
            syntax_limit_b = -102400, -- 100 KB limit on syntax‑highlighting
          },
        },

        winopts = {
          preview = { wrap = true },
        },

        grep = {
          rg_glob = true,
          -- Split "regex --flags" into two return values
          ---@return string, string?
          rg_glob_fn = function(query, _)
            local regex, flags = query:match '^(.-)%s%-%-(.*)$'
            return (regex or query), flags
          end,
        },

        defaults = {
          git_icons = false,
          file_icons = false,
          color_icons = false,
          formatter = 'path.filename_first',
        },
      }

      -- Key‑maps --------------------------------------------------------------
      local map = vim.keymap.set
      local desc = function(d)
        return { desc = d }
      end

      map('n', '<leader>sf', fzf.files, desc 'FZF Files')
      map('n', '<leader>sr', fzf.resume, desc 'FZF Resume')
      map('n', '<leader>sR', fzf.registers, desc 'Registers')
      map('n', '<leader>sm', fzf.marks, desc 'Marks')
      map('n', '<leader>sk', fzf.keymaps, desc 'Keymaps')
      map('n', '<leader>sg', fzf.live_grep, desc 'FZF Grep')
      map('n', '<leader>l', fzf.lines, desc 'FZF Open Buffer Lines')
      map('n', '<leader>b', fzf.buffers, desc 'FZF Buffers')
      map('v', '<C-f>', fzf.grep_visual, desc 'FZF Selection')
      map('n', '<leader>sh', fzf.helptags, desc 'Help Tags')
      map('n', '<leader>sc', fzf.git_bcommits, desc 'Browse File Commits')
      map('n', '<leader>ss', fzf.git_status, desc 'Git Status')
      map('n', '<localleader>d', fzf.lsp_definitions, desc 'Jump to Definition')
      map('n', '<localleader>r', fzf.lsp_references, desc 'LSP References')
      map('n', '<localleader>I', fzf.lsp_implementations, desc 'LSP implementation')
      map('n', '<localleader>D', fzf.lsp_typedefs, desc 'LSP Type Def')

      map('n', '<localleader>ds', function()
        fzf.lsp_document_symbols { winopts = { preview = { wrap = 'wrap' } } }
      end, desc 'Document Symbols')

      map('n', '<localleader>cd', function()
        fzf.diagnostics_document { fzf_opts = { ['--wrap'] = true } }
      end, desc 'Document Diagnostics')

      map('n', '<localleader>ca', function()
        fzf.lsp_code_actions {
          winopts = { relative = 'cursor', row = 1.01, col = 0, height = 0.2, width = 0.4 },
        }
      end, desc 'Code Actions')
    end,
  },
}
