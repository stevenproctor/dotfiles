-- [nfnl] fnl/plugins/tpope.fnl
local util = require("dotfiles.util")
local function bufmap(mode, from, to)
  return util.noremap(mode, from, to, {["local?"] = true})
end
return {{"tpope/vim-dadbod"}, {"tpope/vim-dispatch"}, {"tpope/vim-git", lazy = false}, {"tpope/vim-pathogen"}, {"tpope/vim-rails"}, {"tpope/vim-repeat"}, {"tpope/vim-rhubarb"}, {"tpope/vim-surround"}, {"tpope/vim-unimpaired"}, {"tpope/vim-vinegar", lazy = false}}
