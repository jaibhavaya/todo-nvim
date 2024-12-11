local M = {}

M.setup = function()
  vim.cmd([[
    augroup TodoHighlight
      autocmd!
      autocmd BufRead,BufNewFile ~/.todo/todo*.md setlocal filetype=markdown
      autocmd FileType markdown syntax match TodoIncomplete /^\[ \].*$/
      autocmd FileType markdown syntax match TodoComplete /^\[X\].*$/
      autocmd FileType markdown highlight TodoIncomplete guifg=Yellow ctermfg=Yellow
      autocmd FileType markdown highlight TodoComplete guifg=Green ctermfg=Green
    augroup END
  ]])
end

return M
