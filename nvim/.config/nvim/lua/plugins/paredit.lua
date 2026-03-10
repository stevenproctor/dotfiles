-- [nfnl] fnl/plugins/paredit.fnl
vim.g.paredit_smartjump = 1
local function list_member_3f(xs, x)
  local function _1_(_241)
    return (x == _241)
  end
  return a.some(_1_, a.vals(xs))
end
local function bool__3eint(bool)
  if bool then
    return 1
  else
    return 0
  end
end
local function int__3ebool(x)
  if (0 == x) then
    return false
  else
    return true
  end
end
local function toggle_global_21(x)
  vim.g[x] = bool__3eint(not int__3ebool(a.get(vim.g, x)))
  return nil
end
local paredit_langs = {"clojure", "fennel", "hy", "janet", "julia", "lfe", "lisp", "racket", "scheme", "shen"}
local paredit_host_langs = {"org", "markdown", "asciidoc"}
local function paredit_lang_3f(lang)
  return list_member_3f(paredit_langs, lang)
end
local function _4_()
  return vim.fn.PareditInitBalancingAllBracketsBuffer()
end
vim.api.nvim_create_autocmd({"FileType"}, {pattern = "ruby", callback = _4_})
local function _5_()
  return vim.fn.PareditInitBalancingAllBracketsBuffer()
end
vim.api.nvim_create_autocmd({"FileType"}, {pattern = "javascript", callback = _5_})
local function _6_()
  return vim.fn.PareditInitBalancingAllBracketsBuffer()
end
vim.api.nvim_create_autocmd({"FileType"}, {pattern = "terraform", callback = _6_})
local function _7_()
  local a = require("nfnl.core")
  local ts_parsers = require("nvim-treesitter.parsers")
  local languagetree = require("vim.treesitter.languagetree")
  local function language_at_cursor()
    local parser = ts_parsers.get_parser()
    local current_node = vim.treesitter.get_node({bufnr = 0})
    local range
    if current_node then
      range = {current_node:range()}
    else
      range = nil
    end
    local lang
    if range then
      lang = languagetree.language_for_range(parser, range)
    else
      lang = nil
    end
    if lang then
      return lang:lang()
    else
      return nil
    end
  end
  local function parser_language()
    local parser = ts_parsers.get_parser()
    if parser then
      return parser:lang()
    else
      return nil
    end
  end
  local function host_lang_in_3f(langs)
    return list_member_3f(langs, parser_language())
  end
  local function TreeSitterLangParedit()
    if host_lang_in_3f(paredit_host_langs) then
      local cursor_lang = language_at_cursor()
      if cursor_lang then
        vim.g.paredit_mode = bool__3eint(paredit_lang_3f(cursor_lang))
        return vim.fn.PareditInitBuffer()
      else
        return nil
      end
    else
      return nil
    end
  end
  return TreeSitterLangParedit
end
return {"kovisoft/paredit", config = _7_, dependencies = {"nvim-treesitter/nvim-treesitter"}}
