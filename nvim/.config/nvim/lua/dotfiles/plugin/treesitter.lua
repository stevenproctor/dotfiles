-- [nfnl] fnl/dotfiles/plugin/treesitter.fnl
local treesitter_configs = require("nvim-treesitter.configs")
return treesitter_configs.setup({highlight = {enable = true, additional_vim_regex_highlighting = {"org"}}, ensure_installed = "all"})
