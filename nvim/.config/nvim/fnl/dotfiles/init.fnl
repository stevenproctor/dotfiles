(module dotfiles.init
  {autoload
   {a aniseed.core}
   require
   {nvim aniseed.nvim}})


(require :dotfiles.plugins)
(require :dotfiles.core)
(require :dotfiles.mapping)

;(nvim.ex.source "~/.vimrc")

