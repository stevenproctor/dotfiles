(local core (require :nfnl.core))
(local conjure-config (require :conjure.config))

; (set nvim.g.conjure#eval#result_register "*")
; (set nvim.g.conjure#log#botright true)
(set vim.g.conjure#mapping#doc_word :gk)
(set vim.g.conjure#client#clojure#nrepl#mapping#session_clone :sC)
(set vim.g.conjure#extract#tree_sitter#enabled true)

(conjure-config.assoc-in [:filetypes]
                         (core.concat (conjure-config.filetypes) [:markdown]))

(conjure-config.assoc-in [:filetype :markdown] :conjure.client.clojure.nrepl)
