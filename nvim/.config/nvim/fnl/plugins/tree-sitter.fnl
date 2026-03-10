(import-macros {: tx} :config.macros)

(vim.api.nvim_create_autocmd :FileType
                             {:pattern ["*"]
                              :callback #(vim.schedule #(pcall #(vim.treesitter.start)))})

(tx :nvim-treesitter/nvim-treesitter
    {:branch :main
     :build (fn []
              (let [TS (require :nvim-treesitter)]
                (when (not TS.get_installed)
                  (LazyVim.error "Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch."))
                ; make sure we're using the latest treesitter util
                (set package.loaded.lazyvim.util.treesitter nil)
                (LazyVim.treesitter.build (fn []
                                            (TS.update nil {:summary true})))))
     :opts {:indent {:enable true}
            :highlight {:enable true}
            :folds {:enable true}
            :ensure_installed [:bash
                               :clojure
                               :diff
                               :fennel
                               :html
                               :javascript
                               :jsdoc
                               :json
                               :lua
                               :luadoc
                               :luap
                               :markdown
                               :markdown_inline
                               :regex
                               :toml
                               :vim
                               :vimdoc
                               :xml
                               :yaml]}})
