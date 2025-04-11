-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '✚' },
        change = { text = '➜' },
        delete = { text = '✘' },
        topdelete = { text = '' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', 'gj', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', 'gk', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', 'ghs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', 'ghr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', 'ghS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', 'ghu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', 'ghR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', 'ghp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', 'ghb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', 'ghd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', 'ghD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        map('n', 'gtb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', 'gtD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
