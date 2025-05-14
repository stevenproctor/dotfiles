(local a (require :nfnl.core))
(local str (require :nfnl.string))
(local fs (require :nfnl.fs))

(fn require-all []
  (let [require-exclusions (a.->set [:init])]
    (->> (fs.relglob :fnl/dotfiles :*.fnl)
         (a.map #(a.first (str.split $ :.fnl)))
         (a.filter #(not (a.contains? require-exclusions $)))
         (a.map #(.. :dotfiles. $))
         ;(a.map #(require $))
         )))

;; (require-all)
(require :dotfiles.core)
(require :dotfiles.plugins)
(require :dotfiles.mapping)
(require :dotfiles.conceal)
(require :dotfiles.zoom-toggle)

;(nvim.ex.source "~/.vimrc")
(a.println "(re)loaded")
