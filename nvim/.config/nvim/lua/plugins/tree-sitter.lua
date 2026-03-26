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
return {"nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate", opts = {indent = {enable = true}, highlight = {enable = true}, folds = {enable = true}, ensure_installed = {"bash", "clojure", "diff", "elm", "fennel", "html", "javascript", "jsdoc", "json", "lua", "luadoc", "luap", "markdown", "markdown_inline", "regex", "ruby", "toml", "vim", "vimdoc", "xml", "yaml"}}}
