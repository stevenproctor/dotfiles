-- [nfnl] fnl/dotfiles/plugin/whichkey.fnl
local which_key = require("which-key")
if which_key then
  return which_key.setup({})
else
  return nil
end
