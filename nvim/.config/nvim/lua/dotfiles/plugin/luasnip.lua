-- [nfnl] fnl/dotfiles/plugin/luasnip.fnl
local luasnip = require("luasnip")
local select_choice = require("luasnip.extras.select_choice")
if luasnip then
  local function _1_()
    if luasnip.expand_or_jumpable() then
      return luasnip.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<C-k>", _1_, {silent = true})
  local function _3_()
    if luasnip.jumpable(-1) then
      return luasnip.jump(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<C-j>", _3_, {silent = true})
  local function _5_()
    if luasnip.choice_active() then
      return luasnip.choice(1)
    else
      return nil
    end
  end
  vim.keymap.set("i", "<C-l>", _5_)
  return vim.keymap.set("i", "<C-u>", select_choice)
else
  return nil
end
