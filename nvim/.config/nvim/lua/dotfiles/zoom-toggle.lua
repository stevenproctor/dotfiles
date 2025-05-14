-- [nfnl] fnl/dotfiles/zoom-toggle.fnl
local u = require("dotfiles.util")
local unzoom_21 = nil
local function zoom_toggle()
  if unzoom_21 then
    vim.cmd(unzoom_21)
    unzoom_21 = nil
    return nil
  else
    unzoom_21 = vim.fn.winrestcmd()
    vim.fn.resize()
    return vim.fn.vertical("resize")
  end
end
vim.api.nvim_create_user_command("ZoomToggle", zoom_toggle, {})
u.nnoremap("<M-z>", ":call ZoomToggle()<CR>")
return u.tnoremap("<M-z>", "<c-\\><c-n>:call ZoomToggle()<CR>")
