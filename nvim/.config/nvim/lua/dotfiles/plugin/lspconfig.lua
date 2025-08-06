-- [nfnl] fnl/dotfiles/plugin/lspconfig.fnl
local a = require("nfnl.core")
local u = require("dotfiles.util")
local lsp = require("vim.lsp")
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local function bufmap(mode, from, to, opts)
  return u.noremap(mode, from, to, a.merge({["local?"] = true}, opts))
end
local function nbufmap(from, to, opts)
  return bufmap("n", from, to, opts)
end
local function xbufmap(from, to, opts)
  return bufmap("x", from, to, opts)
end
local function lsp_execute_command(client, cmd, ...)
  local buf_uri = vim.uri_from_bufnr(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local r = (a.first(cursor) - 1)
  local c = a.second(cursor)
  local opts = {buf_uri, r, c}
  local args = a.concat(opts, {...})
  return client.request_sync("workspace/executeCommand", {command = cmd, arguments = args}, nil, 0)
end
vim.diagnostic.config({signs = {text = {[vim.diagnostic.severity.ERROR] = "\226\152\162\239\184\143", [vim.diagnostic.severity.WARN] = "\226\154\160\239\184\143", [vim.diagnostic.severity.INFO] = "\226\132\185\239\184\143", [vim.diagnostic.severity.HINT] = "\240\159\148\142"}}})
local core_nmappings = {gd = "lua vim.lsp.buf.definition()", gD = "lua vim.lsp.buf.declaration()", gi = "lua vim.lsp.buf.implementation()", gr = "lua vim.lsp.buf.references()", K = "lua vim.lsp.buf.hover()", ["[g"] = "lua vim.diagnostic.goto_prev()", ["]g"] = "lua vim.diagnostic.goto_next()", ["<leader>ca"] = "lua vim.lsp.buf.code_action()", ["<leader>cl"] = "lua vim.lsp.codelens.run()", ["<leader>ic"] = "lua vim.lsp.buf.incoming_calls()", ["<leader>sld"] = "lua vim.diagnostic.open_float(nil, {source = 'always'})", ["<leader>rn"] = "lua vim.lsp.buf.rename()", ["<leader>fa"] = "lua vim.lsp.buf.format()"}
local client_nmappings = {clojure_lsp = {}}
local client_command_lnmappings
local function _1_()
  return vim.fn.input("Namespace name: ")
end
local function _2_()
  return vim.fn.input("Namespace name: ")
end
local function _3_()
  return vim.fn.input("Namespace as: ")
end
local function _4_()
  return vim.fn.input("Namespace name: ")
end
local function _5_()
  return vim.fn.input("Definition name: ")
end
local function _6_()
  return vim.fn.input("Function name: ")
end
local function _7_()
  return vim.fn.input("Binding name: ")
end
local function _8_()
  return vim.fn.input("File name: ")
end
local function _9_()
  return vim.fn.input("Binding name: ")
end
local function _10_()
  return vim.fn.input("Function name: ")
end
local function _11_()
  return vim.fn.input("")
end
client_command_lnmappings = {clojure_lsp = {ai = {"add-import-to-namespace", {_1_}}, am = {"add-missing-libspec", {}}, as = {"add-require-suggestion", {_2_, _3_, _4_}}, cc = {"cycle-coll", {}}, cn = {"clean-ns", {}}, cp = {"cycle-privacy", {}}, ct = {"create-test", {}}, df = {"drag-forward", {}}, db = {"drag-backward", {}}, dk = {"destructure-keys", {}}, ed = {"extract-to-def", {_5_}}, ref = {"extract-function", {_6_}}, el = {"expand-let", {}}, fe = {"create-function", {}}, il = {"introduce-let", {_7_}}, is = {"inline-symbol", {}}, ma = {"resolve-macro-as", {}}, mf = {"move-form", {_8_}}, ml = {"move-to-let", {_9_}}, pf = {"promote-fn", {_10_}}, sc = {"change-collection", {_11_, "input('Collection type: ')"}}, sm = {"sort-map", {}}, tf = {"thread-first-all", {}}, tF = {"thread-first", {}}, tl = {"thread-last-all", {}}, tL = {"thread-last", {}}, ua = {"unwind-all", {}}, uw = {"unwind-thread", {}}}}
local server_specific_opts = {}
local function bind_client_mappings(client)
  local client_name = a.get(client, "name")
  local mappings = a.get(client_nmappings, client_name)
  local command_lnmappings = a.get(client_command_lnmappings, client_name)
  if mappings then
    for mapping, cmd in pairs(mappings) do
      nbufmap(mapping, cmd, {})
    end
  else
  end
  if command_lnmappings then
    for lnmapping, command_mapping in pairs(command_lnmappings) do
      local lsp_cmd = a.first(command_mapping)
      local mapping = ("<leader>" .. lnmapping)
      local cmd
      local function _13_()
        local opts
        do
          local s = ""
          for _i, opt in ipairs(a.second(command_mapping)) do
            local _14_
            if ("function" == type(opt)) then
              _14_ = opt()
            else
              _14_ = opt
            end
            s = (s .. _14_)
          end
          opts = s
        end
        return lsp_execute_command(client, lsp_cmd, opts)
      end
      cmd = _13_
      nbufmap(mapping, cmd, {desc = ("LSP command `" .. lsp_cmd .. "`")})
    end
    return nil
  else
    return nil
  end
end
local function on_attach(client, bufnr)
  for mapping, cmd in pairs(core_nmappings) do
    nbufmap(mapping, cmd, {})
  end
  xbufmap("<leader>fa", "lua vim.lsp.buf.format()", {desc = "Format buffer"})
  vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {buf = 0})
  bind_client_mappings(client)
  if client.server_capabilities.documentHighlightProvider then
    for hlgroup, base_group in pairs({LspReferenceRead = "SpecialKey", LspReferenceText = "SpecialKey", LspReferenceWrite = "SpecialKey"}) do
      vim.api.nvim_set_hl(0, hlgroup, a.merge(vim.api.nvim_get_hl_by_name(base_group, true), {italic = true, foreground = "#6c71c4", background = "NONE"}))
    end
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", {clear = true})
    local function _17_()
      return vim.lsp.buf.document_highlight()
    end
    vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {group = group, pattern = "<buffer>", callback = _17_})
    local function _18_()
      return vim.lsp.buf.clear_references()
    end
    vim.api.nvim_create_autocmd({"CursorMoved"}, {group = group, pattern = "<buffer>", callback = _18_})
  else
  end
  if client.server_capabilities.documentFormattingProvider then
    local function _20_()
      return vim.lsp.buf.format()
    end
    vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "<buffer>", callback = _20_})
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
local function setup_handlers(language_servers)
  for _, server_name in pairs(language_servers) do
    default_server_handler(server_name)
  end
  return nil
end
u.nnoremap("<leader>li", "LspInfo")
vim.api.nvim_create_user_command("LspExecuteCommand", lsp_execute_command, {nargs = "+"})
return {on_attach = on_attach, ["default-server-handler"] = default_server_handler, ["setup-handlers"] = setup_handlers}
