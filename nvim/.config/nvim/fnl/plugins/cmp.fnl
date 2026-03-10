(import-macros {: tx} :config.macros)

(tx "hrsh7th/nvim-cmp"
  {:event "VeryLazy"
   :main "cmp"
   :dependencies ["hrsh7th/cmp-nvim-lsp"
                  "hrsh7th/cmp-buffer"
                  "hrsh7th/cmp-path"
                  "hrsh7th/cmp-cmdline"
                  :hrsh7th/vim-vsnip
                  :hrsh7th/vim-vsnip-integ
                  "PaterJason/cmp-conjure"
                  "Olical/conjure"
                  "nvim-lua/plenary.nvim"]

   :config
   (fn []
     (let [cmp (require :cmp)]
       (cmp.setup
         {:sources (cmp.config.sources
                     [{:name "nvim_lsp" :group_index 2}
                      {:name "nvim_lua" :group_index 2}
                      {:name "vsnip" :group_index 2}
                      {:name "conjure" :group_index 2}
                      {:name "buffer" :group_index 2}
                      {:name :orgmode :group_index 2}
                      {:name :emoji  :group_index 2 :max_item_count 8}])
          :sorting {:priority_weight 2
                    :comparators [;; Below is the default comparator list and order for nvim-cmp
                                  cmp.config.compare.offset
                                  ;; cmp.config.compare.scopes --this is commented in nvim-cmp too
                                  cmp.config.compare.exact
                                  cmp.config.compare.score
                                  cmp.config.compare.recently_used
                                  cmp.config.compare.locality
                                  cmp.config.compare.kind
                                  cmp.config.compare.sort_text
                                  cmp.config.compare.length
                                  cmp.config.compare.order]}
          :window {:completion (cmp.config.window.bordered)
                   :documentation (cmp.config.window.bordered)}
          :mapping (cmp.mapping.preset.insert
                     {:<C-p> (cmp.mapping.select_prev_item)
                      :<C-n> (cmp.mapping.select_next_item)
                      "<C-b>" (cmp.mapping.scroll_docs -4)
                      "<C-f>" (cmp.mapping.scroll_docs 4)
                      "<C-Space>" (cmp.mapping.complete)
                      "<C-e>" (cmp.mapping.abort)
                      "<C-y>" (cmp.mapping.confirm {:select true})})})

       ; (cmp.setup.cmdline
       ;   ["/" "?"]
       ;   {:mapping (cmp.mapping.preset.cmdline)
       ;    :sources [{:name "buffer"}]})

       (cmp.setup.cmdline
         ":"
         {:mapping (cmp.mapping.preset.cmdline)
          :sources (cmp.config.sources [{:name "path"} {:name "cmdline"}])
          :matching {:disallow_symbol_nonprefix_matching false}})))})
