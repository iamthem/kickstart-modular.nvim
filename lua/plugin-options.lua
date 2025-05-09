local hop = require 'hop'
local directions = require('hop.hint').HintDirection

vim.keymap.set('', 'f', function()
  hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
end, { remap = true })

vim.keymap.set('', 'F', function()
  hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
end, { remap = true })

vim.keymap.set('', 's', function()
  hop.hint_char2 { direction = directions.AFTER_CURSOR, current_line_only = false }
end, { remap = true })

vim.keymap.set('', 'S', function()
  hop.hint_char2 { direction = directions.BEFORE_CURSOR, current_line_only = false }
end, { remap = true })

vim.keymap.set('', 'mw', function()
  hop.hint_words { direction = directions.AFTER_CURSOR, current_line_only = false }
end, { remap = true })

local neogit = require 'neogit'
vim.keymap.set('', 'gm', function()
  neogit.open()
end, { remap = true })
