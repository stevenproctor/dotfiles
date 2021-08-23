(module dotfiles.plugin.easyalign
  {autoload {nvim aniseed.nvim
             util dotfiles.util }})

(util.noremap :v :<leader><bslash> "EasyAlign*<Bar>")

;;(nvim.ex.autocmd :BufWritePre :<buffer> :lua "vim.lsp.buf.formatting_sync()")
