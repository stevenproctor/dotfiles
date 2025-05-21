-- [nfnl] fnl/dotfiles/util.fnl
local a = require("nfnl.core")
local function fn_3f(x)
  return ("function" == type(x))
end
local function noremap(mode, from, to, opts)
  local map_opts = {noremap = true, silent = true}
  local to0
  if fn_3f(to) then
    to0 = to
  else
    to0 = (":" .. to .. "<cr>")
  end
  local buff_num = a.get(opts, "buff-num")
  if (a.get(opts, "local?") or buff_num) then
    return vim.keymap.set(mode, from, to0, a.merge(map_opts, {buffer = (buff_num or 0)}))
  else
    return vim.keymap.set(mode, from, to0, map_opts)
  end
end
local function nnoremap(from, to, opts)
  return noremap("n", from, to, opts)
end
local function tnoremap(from, to, opts)
  return noremap("t", from, to, opts)
end
local function inoremap(from, to, opts)
  return noremap("i", from, to, opts)
end
local function vnoremap(from, to, opts)
  return noremap("v", from, to, opts)
end
local function lnnoremap(from, to)
  return nnoremap(("<leader>" .. from), to)
end
local function ltnoremap(from, to, opts)
  return noremap("v", ("<leader>" .. from), to, opts)
end
local function lvnoremap(from, to, opts)
  return noremap("t", ("<leader>" .. from), to, opts)
end
return {noremap = noremap, nnoremap = nnoremap, tnoremap = tnoremap, inoremap = inoremap, vnoremap = vnoremap, lnnoremap = lnnoremap, ltnoremap = ltnoremap, lvnoremap = lvnoremap}
