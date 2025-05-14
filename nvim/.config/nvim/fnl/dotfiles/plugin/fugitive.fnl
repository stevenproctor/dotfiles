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
