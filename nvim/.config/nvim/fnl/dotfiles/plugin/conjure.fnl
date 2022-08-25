(module dotfiles.plugin.conjure
  {autoload {a aniseed.core
             conjure-config conjure.config
             nvim aniseed.nvim}})

; (set nvim.g.conjure#eval#result_register "*")
; (set nvim.g.conjure#log#botright true)
(set nvim.g.conjure#mapping#doc_word "gk")
(set nvim.g.conjure#client#clojure#nrepl#mapping#session_clone :sC)
(set nvim.g.conjure#extract#tree_sitter#enabled true)

(conjure-config.assoc-in [:filetypes] (a.concat (conjure-config.filetypes) [:markdown] ))
(conjure-config.assoc-in [:filetype :markdown] "conjure.client.clojure.nrepl")
