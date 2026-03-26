(import-macros {: tx} :config.macros)

(vim.api.nvim_create_autocmd :FileType
                             {:pattern ["*"]
                              :callback #(vim.schedule #(pcall #(vim.treesitter.start)))})

(tx :nvim-treesitter/nvim-treesitter
    {:branch :main
     :build ":TSUpdate"
     :opts {:indent {:enable true}
            :highlight {:enable true}
            :folds {:enable true}
            :ensure_installed [:bash
                               :clojure
                               :diff
                               :elm
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
                               :ruby
                               :toml
                               :vim
                               :vimdoc
                               :xml
                               :yaml]}})
