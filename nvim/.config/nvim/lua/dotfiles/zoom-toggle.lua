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
    vim.cmd.resize()
    return vim.cmd.resize({mods = {vertical = true}})
  end
end
vim.api.nvim_create_user_command("ZoomToggle", zoom_toggle, {})
local wk = require("which-key")
return wk.add({{{"<M-z>", zoom_toggle, desc = "Toggle zoom of buffer window"}}, {{"<M-z>", zoom_toggle, desc = "Toggle zoom of buffer window", mode = {"n", "t"}}}})
