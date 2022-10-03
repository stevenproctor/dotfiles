(module dotfiles.init
  {autoload
   {a aniseed.core}
   require
   {nvim aniseed.nvim}})


(require :dotfiles.core)
(require :dotfiles.plugins)
(require :dotfiles.mapping)
(require :dotfiles.conceal)
(require :dotfiles.zoom-toggle)

;(nvim.ex.source "~/.vimrc")

(a.println "(re)loaded")
