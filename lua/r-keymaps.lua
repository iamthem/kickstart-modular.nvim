-- r-keymaps.lua  ── fixed
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'r', 'rmd', 'rmarkdown' },
  callback = function()
    -- just one table; no second arg
    vim.diagnostic.config {
      virtual_text = false,
      severity_sort = true,
      severity = { min = vim.diagnostic.severity.WARN },
    }
  end,
})
