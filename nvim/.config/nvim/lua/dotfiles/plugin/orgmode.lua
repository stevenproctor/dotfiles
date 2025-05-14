-- [nfnl] fnl/dotfiles/plugin/orgmode.fnl
local orgmode = require("orgmode")
orgmode.setup({org_agenda_files = {"~/Dropbox/org/*", "~/my-orgs/**/*"}, org_default_notes_file = "~/Dropbox/org/refile.org", mappings = {org = {org_toggle_checkbox = "<C-.>"}}})
return require("dotfiles.plugin.orgbullets")
