(module dotfiles.plugin.fugitive
  {autoload {nvim aniseed.nvim
             nu aniseed.nvim.util
             core aniseed.core
             util dotfiles.util}})

;; Determine load time of fugitive
(nvim.ex.autocmd :FileType :fugitive :nmap :<buffer> :<leader>gp ":Git pull<CR>")
(nvim.ex.autocmd :FileType :fugitive :nmap :<buffer> :<leader>gP ":Git push<CR>" )
(nvim.ex.autocmd :FileType :fugitive :nmap :<buffer> :<leader>gF ":Git push -f<CR>" )
