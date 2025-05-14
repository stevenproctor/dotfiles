-- [nfnl] fnl/dotfiles/plugin/easyalign.fnl
local util = require("dotfiles.util")
return util.noremap("v", "<leader><bslash>", "EasyAlign*<Bar>")
