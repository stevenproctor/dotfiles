-- [nfnl] fnl/dotfiles/plugin/mason.fnl
local mason = require("mason")
local mason_lspconf = require("mason-lspconfig")
local lspconfig = require("dotfiles.plugin.lspconfig")
local function setup()
  mason.setup({ui = {icons = {package_installed = "\226\156\147"}}})
  if mason_lspconf then
    mason_lspconf.setup({ensure_installed = {"lua_ls"}, automatic_enable = true})
    return lspconfig["setup-handlers"](mason_lspconf.get_installed_servers())
  else
    return nil
  end
end
return setup()
