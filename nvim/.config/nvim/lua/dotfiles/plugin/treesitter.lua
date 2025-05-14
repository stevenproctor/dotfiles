-- [nfnl] fnl/dotfiles/plugin/treesitter.fnl
local treesitter_configs = require("nvim-treesitter.configs")
return treesitter_configs.setup({highlight = {enable = true, additional_vim_regex_highlighting = {"org"}}, ensure_installed = "all", rainbow = {enable = true, extended_mode = true, max_file_lines = 10000, colors = {"#dc322f", "#b58900", "#d33682", "#859900", "#2aa198", "#268bd2", "#6c71c4"}}})
