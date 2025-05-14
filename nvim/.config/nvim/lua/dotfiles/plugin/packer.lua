-- [nfnl] fnl/dotfiles/plugin/packer.fnl
local u = require("dotfiles.util")
u.nnoremap("<leader>pi", "PackerInstall")
return u.nnoremap("<leader>pu", "PackerUpdate")
