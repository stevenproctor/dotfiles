(module dotfiles.plugin.packer
  {autoload
   {u dotfiles.util}
   require
   {nvim aniseed.nvim}})

(u.nnoremap :<leader>pi :PackerInstall)
(u.nnoremap :<leader>pu :PackerUpdate)

