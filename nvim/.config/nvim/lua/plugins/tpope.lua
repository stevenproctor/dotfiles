-- [nfnl] fnl/plugins/tpope.fnl
local util = require("dotfiles.util")
local function bufmap(mode, from, to)
  return util.noremap(mode, from, to, {["local?"] = true})
end
local function map_fugitive_keys()
  bufmap("n", "<leader>gp", ":Git pull<CR>")
  bufmap("n", "<leader>gP", ":Git push<CR>")
  return bufmap("n", "<leader>gF", ":Git push -f<CR>")
end
vim.api.nvim_create_autocmd({"FileType"}, {pattern = "fugitive", callback = map_fugitive_keys})
return {{"tpope/vim-dadbod"}, {"tpope/vim-dispatch"}, {"tpope/vim-fugitive"}, {"tpope/vim-git", lazy = false}, {"tpope/vim-pathogen"}, {"tpope/vim-rails"}, {"tpope/vim-repeat"}, {"tpope/vim-rhubarb"}, {"tpope/vim-surround"}, {"tpope/vim-unimpaired"}, {"tpope/vim-vinegar", lazy = false}}
