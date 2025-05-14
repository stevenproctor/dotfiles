-- [nfnl] fnl/dotfiles/plugin/colorizer.fnl
local colorizer = require("colorizer")
return colorizer.setup({"*"}, {RGB = true, RRGGBB = true, names = true, RRGGBBAA = true, rgb_fn = true, hsl_fn = true, css = true, css_fn = true})
