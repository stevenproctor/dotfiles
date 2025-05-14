-- [nfnl] fnl/dotfiles/init.fnl
local a = require("nfnl.core")
local str = require("nfnl.string")
local fs = require("nfnl.fs")
local function require_all()
  local require_exclusions = a["->set"]({"init"})
  local function _1_(_241)
    return ("dotfiles." .. _241)
  end
  local function _2_(_241)
    return not a["contains?"](require_exclusions, _241)
  end
  local function _3_(_241)
    return a.first(str.split(_241, ".fnl"))
  end
  return a.map(_1_, a.filter(_2_, a.map(_3_, fs.relglob("fnl/dotfiles", "*.fnl"))))
end
require("dotfiles.core")
require("dotfiles.plugins")
require("dotfiles.mapping")
require("dotfiles.conceal")
require("dotfiles.zoom-toggle")
return a.println("(re)loaded")
