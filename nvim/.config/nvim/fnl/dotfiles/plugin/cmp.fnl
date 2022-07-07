(module dotfiles.plugin.cmp
  {autoload {nvim aniseed.nvim}})


(module config.plugin.cmp
  {autoload {nvim aniseed.nvim
             cmp cmp}})

(def- cmp-src-menu-items
  {:buffer "buff"
   :conjure "conj"
   :nvim_lsp "lsp"})

(def- cmp-srcs
  [{:name :nvim_lsp}
   {:name :vsnip}
   {:name :conjure}
   {:name :buffer}])

;; Setup cmp with desired settings
(let [cmp (require :cmp)]
  (cmp.setup {:formatting
              {:format (fn [entry item]
                         (set item.menu (or (. cmp-src-menu-items entry.source.name) ""))
                         item)}
              :mapping {:<C-p> (cmp.mapping.select_prev_item)
                        :<C-n> (cmp.mapping.select_next_item)
                        :<C-b> (cmp.mapping.scroll_docs (- 4))
                        :<C-f> (cmp.mapping.scroll_docs 4)
                        :<C-Space> (cmp.mapping.complete)
                        :<C-e> (cmp.mapping.close)
                        :<CR> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Insert
                                                    :select true})}

              :snippet {:expand (fn [args]
                                  (nvim.fn.vsnip#anonymous args.body))}
              :sources cmp-srcs}))


;;; imap <expr> <C-j>   vsnip#available(1)  ? '<Plug>(vsnip-expand)'         : '<C-j>'
;;; imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
;;; smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'