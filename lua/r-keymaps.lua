vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'r', 'rmd' },
  callback = function()
    vim.keymap.set('i', 'PP', '%>%', { silent = true, noremap = true, desc = desc })
    vim.keymap.set('i', '--', '<- ', { silent = true, noremap = true, desc = desc })
  end,
})
