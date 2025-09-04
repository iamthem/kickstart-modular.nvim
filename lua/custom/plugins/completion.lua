return {
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
      require('nvim-autopairs').remove_rule '`'
    end,
  },

  { -- new completion plugin
    'saghen/blink.cmp',
    build = 'cargo +nightly build --release',
    enabled = true,
    version = '*',
    dev = false,
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    lazy = false,
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
      { 'moyiz/blink-emoji.nvim' },
      { 'Kaiser-Yang/blink-cmp-git' },
      {
        'saghen/blink.compat',
        dev = false,
        opts = { impersonate_nvim_cmp = true, enable_events = true, debug = true },
      },
      { 'kdheepak/cmp-latex-symbols' },
      { 'giuxtaposition/blink-cmp-copilot' },

      { -- <── NEW PLUGIN
        'milanglacier/minuet-ai.nvim',
        lazy = false,
        dependencies = { 'nvim-lua/plenary.nvim' }, -- required
        opts = {
          notify = 'warn',
          provider = 'gemini',
          throttle = 500,
          provider_options = {
            gemini = {
              model = 'gemini-2.5-flash',
              -- remove or replace the next three placeholders; here we just drop them
              -- system = 'see [Prompt] section for the default value',
              -- few_shots = 'see [Prompt] section for the default value',
              -- chat_input = 'See [Prompt Section for default value]',
              stream = true,
              api_key = 'GEMINI_API_KEY',
              end_point = 'https://generativelanguage.googleapis.com/v1beta/models',
              optional = {
                generationConfig = {
                  maxOutputTokens = 512,
                  -- When using `gemini-2.5-flash`, it is recommended to entirely
                  -- disable thinking for faster completion retrieval.
                  thinkingConfig = {
                    thinkingBudget = 0,
                  },
                },
                safetySettings = {
                  {
                    -- HARM_CATEGORY_HATE_SPEECH,
                    -- HARM_CATEGORY_HARASSMENT
                    -- HARM_CATEGORY_SEXUALLY_EXPLICIT
                    category = 'HARM_CATEGORY_DANGEROUS_CONTENT',
                    -- BLOCK_NONE
                    threshold = 'BLOCK_ONLY_HIGH',
                  },
                },
              },
            },
          },
        },
      },
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = function()
      local minuet = require 'minuet'
      return {
        keymap = {
          preset = 'enter',
          ['<c-y>'] = { 'show_documentation', 'hide_documentation' },
          ['<Tab>'] = false,
          ['<c-g>'] = minuet.make_blink_map(),
        },
        cmdline = {
          enabled = false,
        },
        sources = {
          default = { 'lazydev', 'lsp', 'path', 'git', 'snippets', 'buffer', 'emoji', 'copilot', 'minuet' },
          providers = {
            emoji = {
              module = 'blink-emoji',
              name = 'Emoji',
              score_offset = -1,
            },
            minuet = {
              name = 'minuet',
              module = 'minuet.blink',
              async = true,
              -- Should match minuet.config.request_timeout * 1000,
              -- since minuet.config.request_timeout is in seconds
              timeout_ms = 3000,
              score_offset = 50, -- Gives minuet higher priority among suggestions
            },
            lazydev = {
              name = 'LazyDev',
              module = 'lazydev.integrations.blink',
              -- make lazydev completions top priority (see `:h blink.cmp`)
              score_offset = 100,
            },
            git = {
              module = 'blink-cmp-git',
              name = 'Git',
              opts = {},
              enabled = function()
                return vim.tbl_contains({ 'octo', 'gitcommit', 'git' }, vim.bo.filetype)
              end,
            },
            symbols = { name = 'symbols', module = 'blink.compat.source' },
            copilot = {
              name = 'copilot',
              module = 'blink-cmp-copilot',
              score_offset = 100,
              async = true,
            },
          },
        },
        appearance = {
          -- Sets the fallback highlight groups to nvim-cmp's highlight groups
          -- Useful for when your theme doesn't support blink.cmp
          -- Will be removed in a future release
          use_nvim_cmp_as_default = true,
          -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
          kind_icons = {
            -- LLM Provider icons
            claude = '󰋦',
            openai = '󱢆',
            codestral = '󱎥',
            gemini = '',
            Groq = '',
            Openrouter = '󱂇',
            Deepseek = '',
          },
        },
        completion = {
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 100,
            treesitter_highlighting = true,
          },
          menu = {
            auto_show = true,
          },
          trigger = { prefetch_on_insert = false },
        },
      }
    end,
    signature = { enabled = true },
  },
}
