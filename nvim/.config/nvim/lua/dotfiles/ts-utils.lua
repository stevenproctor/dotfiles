-- [nfnl] fnl/dotfiles/ts-utils.fnl
local core = require("nfnl.core")
local function root(bufnr, lang)
  local parser = vim.treesitter.get_parser(bufnr, lang, {})
  local tree = core.first(parser:parse())
  return tree:root()
end
local function make_query(lang, query_string)
  local query = vim.treesitter.query.parse(lang, "(headline (stars) @stars)")
  local function _1_(bufnr)
    local root_node = root(bufnr, lang)
    local iter_captures = query.iter_captures(query, root_node, bufnr, 0, -1)
    return iter_captures
  end
  return _1_
end
return {root = root, ["make-query"] = make_query}
