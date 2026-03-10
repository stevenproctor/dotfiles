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
  local TS = require("nvim-treesitter")
  if not TS.get_installed then
    LazyVim.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
  else
  end
  package.loaded.lazyvim.util.treesitter = nil
  local function _6_()
    return TS.update(nil, {summary = true})
  end
  return LazyVim.treesitter.build(_6_)
end
return {"nvim-treesitter/nvim-treesitter", branch = "main", build = _4_, opts = {indent = {enable = true}, highlight = {enable = true}, folds = {enable = true}, ensure_installed = {"bash", "clojure", "diff", "fennel", "html", "javascript", "jsdoc", "json", "lua", "luadoc", "luap", "markdown", "markdown_inline", "regex", "toml", "vim", "vimdoc", "xml", "yaml"}}}
