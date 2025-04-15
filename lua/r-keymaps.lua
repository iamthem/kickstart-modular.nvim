vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'r', 'rmd', 'rmarkdown' },
  callback = function(args)
    vim.diagnostic.config({
      severity = { min = vim.diagnostic.severity.WARN },
    }, args.buf)
  end,
})
