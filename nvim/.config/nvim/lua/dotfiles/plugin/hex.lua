-- [nfnl] fnl/dotfiles/plugin/hex.fnl
local hex = require("hex")
if hex then
  return hex.setup()
else
  return nil
end
