-- [nfnl] fnl/plugins/tree-sitter.fnl
local function _1_()
  local function _2_()
    local function _3_()
      return vim.treesitter.start()
    end
    return pcall(_3_)
  end
  return vim.schedule(_2_)
end
vim.api.nvim_create_autocmd("FileType", {pattern = {"*"}, callback = _1_})
local function _4_()
  local treesitter_configs = require("nvim-treesitter.config")
  return treesitter_configs.setup({highlight = {enable = true, additional_vim_regex_highlighting = {"org"}}, ensure_installed = "all", rainbow = {enable = true, extended_mode = true, max_file_lines = 10000, colors = {"#dc322f", "#b58900", "#d33682", "#859900", "#2aa198", "#268bd2", "#6c71c4"}}})
end
return {"nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", config = _4_, main = "nvim-treesitter.configs"}
