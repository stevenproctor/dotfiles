(import-macros {: tx} :config.macros)

(local util (require :dotfiles.util))
;; Determine load time of fugitive
;; (vim.api.nvim_create_autocmd [:FileType] {:pattern ftype :callback setup-conceals})

(fn bufmap [mode from to] (util.noremap mode from to {:local? true}))

(fn map-fugitive-keys []
  (bufmap :n :<leader>gp ":Git pull<CR>")
  (bufmap :n :<leader>gP ":Git push<CR>")
  (bufmap :n :<leader>gF ":Git push -f<CR>"))

(vim.api.nvim_create_autocmd [:FileType]
                             {:pattern :fugitive :callback map-fugitive-keys})

[(tx :tpope/vim-dadbod {})
(tx :tpope/vim-dispatch {})
(tx :tpope/vim-fugitive {})
(tx :tpope/vim-git {:lazy false})
(tx :tpope/vim-pathogen {})
(tx :tpope/vim-rails {})
(tx :tpope/vim-repeat {})
(tx :tpope/vim-rhubarb {})
(tx :tpope/vim-surround {})
(tx :tpope/vim-unimpaired {})
(tx :tpope/vim-vinegar {:lazy false})]

