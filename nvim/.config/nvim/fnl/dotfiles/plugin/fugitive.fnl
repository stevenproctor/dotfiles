(module dotfiles.plugin.fugitive
  {autoload {nvim aniseed.nvim
             nu aniseed.nvim.util
             core aniseed.core
             util dotfiles.util}})

(nvim.ex.autocmd :FileType :fugitive :nmap :<leader>gp ":Git pull --rebase<CR>")
(nvim.ex.autocmd :FileType :fugitive :nmap :<leader>gP (.. ":Git push origin " (nvim.fn.FugitiveHead) "<CR>"))
