-- [nfnl] fnl/dotfiles/plugin/null-ls.fnl
local null_ls = require("null-ls")
local lspconfig = require("dotfiles.plugin.lspconfig")
if null_ls then
  local null_ls_server_options = {sources = {null_ls.builtins.formatting.stylua, null_ls.builtins.formatting.fnlfmt}, on_attach = lspconfig.on_attach}
  return null_ls.setup(null_ls_server_options)
else
  return nil
end
