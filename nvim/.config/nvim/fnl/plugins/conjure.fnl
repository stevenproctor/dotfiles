(import-macros {: tx} :config.macros)

;; (local conjure-config (require :conjure.config))

; (set nvim.g.conjure#eval#result_register "*")
; (set nvim.g.conjure#log#botright true)
(set vim.g.conjure#mapping#doc_word :gk)
(set vim.g.conjure#log#linked_to_client_state true)
(set vim.g.conjure#client#clojure#nrepl#mapping#session_clone :sC)
(set vim.g.conjure#extract#tree_sitter#enabled true)
(set vim.g.conjure#filetype#fennel :conjure.client.fennel.nfnl)
(set vim.g.conjure#log#trim#at 1000000)

;; (conjure-config.assoc-in [:filetypes]
;;                         (core.concat (conjure-config.filetypes) [:markdown]))

;; (conjure-config.assoc-in [:filetype :markdown] :conjure.client.clojure.nrepl)

(tx :Olical/conjure
    {:event :VeryLazy
     :dependencies [:NeogitOrg/neogit]
     :config (lambda []
               (let [a (require :nfnl.core)
                     group (vim.api.nvim_create_augroup :ConjureSetClientStateOnGitBranchCheckout
                                                        {:clear true})]
                 (vim.api.nvim_create_autocmd [:User]
                                              {: group
                                               :pattern :NeogitBranchCheckout
                                               :callback (lambda [e]
                                                           (let [branch (a.get-in e
                                                                                  [:data
                                                                                   :branch_name])
                                                                 feature (a.first (icollect [s (string.gmatch branch
                                                                                                              "[^/]*")]
                                                                                    s))]
                                                             (vim.cmd.ConjureClientState feature)
                                                             false))})))})
