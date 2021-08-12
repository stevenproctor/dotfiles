(module my_vim.init
  {autoload
   {a aniseed.core}
   require
   {nvim aniseed.nvim}})

(nvim.ex.source "~/.vimrc")

(require :my_nvim.core)
(require :my_nvim.mapping)
