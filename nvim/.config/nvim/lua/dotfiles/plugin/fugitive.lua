-- [nfnl] fnl/dotfiles/plugin/fugitive.fnl
local util = require("dotfiles.util")
local function bufmap(mode, from, to)
  return util.noremap(mode, from, to, {["local?"] = true})
end
local function map_fugitive_keys()
  bufmap("n", "<leader>gp", ":Git pull<CR>")
  bufmap("n", "<leader>gP", ":Git push<CR>")
  return bufmap("n", "<leader>gF", ":Git push -f<CR>")
end
return vim.api.nvim_create_autocmd({"FileType"}, {pattern = "fugitive", callback = map_fugitive_keys})
