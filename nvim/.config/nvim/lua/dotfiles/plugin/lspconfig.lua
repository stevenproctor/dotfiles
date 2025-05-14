-- [nfnl] fnl/dotfiles/plugin/lspconfig.fnl
local a = require("nfnl.core")
local u = require("dotfiles.util")
local lsp = require("vim.lsp")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local function bufmap(mode, from, to)
  return u.noremap(mode, from, to, {["local?"] = true})
end
local function nbufmap(from, to)
  return bufmap("n", from, to)
end
local function xbufmap(from, to)
  return bufmap("x", from, to)
end
vim.diagnostic.config({signs = {text = {[vim.diagnostic.severity.ERROR] = "\226\152\162\239\184\143", [vim.diagnostic.severity.WARN] = "\226\154\160\239\184\143", [vim.diagnostic.severity.INFO] = "\226\132\185\239\184\143", [vim.diagnostic.severity.HINT] = "\240\159\148\142"}}})
local core_nmappings = {gd = "lua vim.lsp.buf.definition()", gD = "lua vim.lsp.buf.declaration()", gi = "lua vim.lsp.buf.implementation()", gr = "lua vim.lsp.buf.references()", K = "lua vim.lsp.buf.hover()", ["[g"] = "lua vim.diagnostic.goto_prev()", ["]g"] = "lua vim.diagnostic.goto_next()", ["<leader>ca"] = "lua vim.lsp.buf.code_action()", ["<leader>cl"] = "lua vim.lsp.codelens.run()", ["<leader>ic"] = "lua vim.lsp.buf.incoming_calls()", ["<leader>sld"] = "lua vim.diagnostic.open_float(nil, {source = 'always'})", ["<leader>rn"] = "lua vim.lsp.buf.rename()", ["<leader>fa"] = "lua vim.lsp.buf.format()"}
local client_nmappings = {clojure_lsp = {["<leader>cn"] = "call LspExecuteCommand('clean-ns')", ["<leader>ref"] = "call LspExecuteCommand('extract-function', input('Function name: '))", ["<leader>id"] = "call LspExecuteCommand('inline-symbol')", ["<leader>il"] = "call LspExecuteCommand('introduce-let', input('Binding name: '))", ["<leader>m2l"] = "call LspExecuteCommand('move-to-let', input('Binding name: '))"}}
local client_command_lnmappings = {clojure_lsp = {ai = {"add-import-to-namespace", {"input('Namespace name: ')"}}, am = {"add-missing-libspec", {}}, as = {"add-require-suggestion", {"input('Namespace name: ')", "input('Namespace as: ')", "input('Namespace name: ')"}}, cc = {"cycle-coll", {}}, cn = {"clean-ns", {}}, cp = {"cycle-privacy", {}}, ct = {"create-test", {}}, df = {"drag-forward", {}}, db = {"drag-backward", {}}, dk = {"destructure-keys", {}}, ed = {"extract-to-def", {"input('Definition name: ')"}}, ef = {"extract-function", {"input('Function name: ')"}}, el = {"expand-let", {}}, fe = {"create-function", {}}, il = {"introduce-let", {"input('Binding name: ')"}}, is = {"inline-symbol", {}}, ma = {"resolve-macro-as", {}}, mf = {"move-form", {"input('File name: ')"}}, ml = {"move-to-let", {"input('Binding name: ')"}}, pf = {"promote-fn", {"input('Function name: ')"}}, sc = {"change-collection", {"input('Collection type: ')"}}, sm = {"sort-map", {}}, tf = {"thread-first-all", {}}, tF = {"thread-first", {}}, tl = {"thread-last-all", {}}, tL = {"thread-last", {}}, ua = {"unwind-all", {}}, uw = {"unwind-thread", {}}}}
local server_specific_opts = {}
local function bind_client_mappings(client)
  local client_name = a.get(client, "name")
  local mappings = a.get(client_nmappings, client_name)
  local command_lnmappings = a.get(client_command_lnmappings, client_name)
  if mappings then
    for mapping, cmd in pairs(mappings) do
      nbufmap(mapping, cmd)
    end
  else
  end
  if command_lnmappings then
    for lnmapping, command_mapping in pairs(command_lnmappings) do
      local lsp_cmd = a.first(command_mapping)
      local opts_str
      do
        local s = ""
        for i, opt in ipairs(a.second(command_mapping)) do
          s = (s .. ", " .. opt)
        end
        opts_str = s
      end
      local mapping = ("<leader>" .. lnmapping)
      local cmd = ("call LspExecuteCommand('" .. lsp_cmd .. "'" .. opts_str .. ")")
      nbufmap(mapping, cmd)
    end
    return nil
  else
    return nil
  end
end
local function on_attach(client, bufnr)
  for mapping, cmd in pairs(core_nmappings) do
    nbufmap(mapping, cmd)
  end
  xbufmap("<leader>fa", "lua vim.lsp.buf.format()")
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {buf = 0})
  bind_client_mappings(client)
  if client.server_capabilities.documentFormattingProvider then
    local function _3_()
      return vim.lsp.buf.format()
    end
    vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "<buffer>", callback = _3_})
  else
  end
  return print("LSP Client Attached.")
end
local base_server_opts
do
  local capabilities = cmp_nvim_lsp.default_capabilities(lsp.protocol.make_client_capabilities())
  base_server_opts = {on_attach = on_attach, capabilities = capabilities, flags = {debounce_text_changes = 150}}
end
local function default_server_handler(server_name)
  local specific_opts = a.get(server_specific_opts, server_name, {})
  local server_opts = a.merge(base_server_opts, specific_opts)
  return vim.lsp.config(server_name, server_opts)
end
local function lsp_execute_command(cmd, ...)
  local buf_uri = vim.uri_from_bufnr(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local r = (a.first(cursor) - 1)
  local c = a.second(cursor)
  local opts = {buf_uri, r, c}
  local args = a.concat(opts, {...})
  return vim.lsp.buf.execute_command({command = cmd, arguments = args})
end
local function setup_handlers(language_servers)
  for _, server_name in pairs(language_servers) do
    default_server_handler(server_name)
  end
  return nil
end
u.nnoremap("<leader>li", "LspInfo")
vim.api.nvim_create_user_command("LspExecuteCommand", lsp_execute_command, {})
return {on_attach = on_attach, ["default-server-handler"] = default_server_handler, ["setup-handlers"] = setup_handlers}
