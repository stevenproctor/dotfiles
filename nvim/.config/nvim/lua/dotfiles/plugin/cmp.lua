-- [nfnl] fnl/dotfiles/plugin/cmp.fnl
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_src_menu_items = {buffer = "buff", conjure = "conj", nvim_lsp = "lsp"}
local cmp_srcs = {{name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "luasnip"}, {name = "vsnip"}, {name = "conjure"}, {name = "buffer"}, {name = "orgmode"}, {name = "emoji", max_item_count = 8}}
local cmp0 = require("cmp")
local function _1_(entry, item)
  item.menu = (cmp_src_menu_items[entry.source.name] or "")
  return item
end
local function _2_(args)
  if args then
    return luasnip.lsp_expand(args.body)
  else
    return nil
  end
end
return cmp0.setup({formatting = {format = _1_}, mapping = {["<C-p>"] = cmp0.mapping.select_prev_item(), ["<C-n>"] = cmp0.mapping.select_next_item(), ["<C-b>"] = cmp0.mapping.scroll_docs(( - 4)), ["<C-f>"] = cmp0.mapping.scroll_docs(4), ["<C-Space>"] = cmp0.mapping.complete(), ["<C-e>"] = cmp0.mapping.close(), ["<C-y>"] = cmp0.mapping.confirm({select = true})}, snippet = {expand = _2_}, sources = cmp_srcs})
