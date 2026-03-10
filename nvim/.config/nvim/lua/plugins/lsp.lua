-- [nfnl] fnl/plugins/lsp.fnl
vim.diagnostic.config({signs = {text = {[vim.diagnostic.severity.ERROR] = "\226\152\162\239\184\143", [vim.diagnostic.severity.WARN] = "\226\154\160\239\184\143", [vim.diagnostic.severity.INFO] = "\226\132\185\239\184\143", [vim.diagnostic.severity.HINT] = "\240\159\148\142"}}})
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
local vim = _G.vim
local lsps = {"clojure_lsp", "lua_ls", "jsonls", "yamlls", "marksman", "html", "basedpyright", "ts_ls", "terraformls", "dockerls", "docker_compose_language_service", "bashls", "taplo", "sqlls"}
local filetype__3eformatters = {lua = {"stylua"}, sh = {"shfmt"}, python = {"ruff_organize_imports", "ruff_format"}, rust = {"rustfmt"}, toml = {"taplo"}, clojure = {"cljfmt"}, json = {"prettierd"}, javascript = {"prettierd"}, typescript = {"prettierd"}, jsx = {"prettierd"}, html = {"prettierd"}, css = {"prettierd"}, yaml = {"prettierd"}, markdown = {"prettierd"}, fennel = {"fnlfmt"}, sql = {"sqlfmt"}, gleam = {"gleam"}, ["*"] = {"trim_whitespace", "trim_newlines"}}
local formatter__3epackage = {ruff_organize_imports = "ruff", ruff_format = "ruff"}
local disable_formatter_on_save = {fennel = true, sql = true}
local disable_formatter_auto_install = {cljfmt = true, fnlfmt = true, rustfmt = true, trim_whitespace = true, trim_newlines = true, gleam = true}
vim.lsp.enable({"clojure", "fennel-ls", "typedclojure"})
local function _12_()
  local caps = require("cmp_nvim_lsp").default_capabilities()
  local mlsp = require("mason-lspconfig")
  local a = require("nfnl.core")
  local u = require("dotfiles.util")
  local lsp = require("vim.lsp")
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  vim.lsp.enable("gleam")
  local function bufmap(mode, from, to, opts)
    return u.noremap(mode, from, to, a.merge({["local?"] = true}, opts))
  end
  local function nbufmap(from, to, opts)
    return bufmap("n", from, to, opts)
  end
  local function xbufmap(from, to, opts)
    return bufmap("x", from, to, opts)
  end
  u.nnoremap("<leader>li", "LspInfo")
  local function lsp_execute_command(client, cmd, ...)
    local buf_uri = vim.uri_from_bufnr(0)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local r = (a.first(cursor) - 1)
    local c = a.second(cursor)
    local opts = {buf_uri, r, c}
    local args = a.concat(opts, {...})
    return client.request_sync("workspace/executeCommand", {command = cmd, arguments = args}, nil, 0)
  end
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
        local function _14_()
          local opts
          do
            local s = ""
            for _i, opt in ipairs(a.second(command_mapping)) do
              local _15_
              if ("function" == type(opt)) then
                _15_ = opt()
              else
                _15_ = opt
              end
              s = (s .. _15_)
            end
            opts = s
          end
          return lsp_execute_command(client, lsp_cmd, opts)
        end
        cmd = _14_
        nbufmap(mapping, cmd, {desc = ("LSP command `" .. lsp_cmd .. "`")})
      end
      return nil
    else
      return nil
    end
  end
  local function on_attach(client, bufnr)
    vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", {buf = 0})
    bind_client_mappings(client)
    if client.server_capabilities.documentHighlightProvider then
      for hlgroup, base_group in pairs({LspReferenceRead = "SpecialKey", LspReferenceText = "SpecialKey", LspReferenceWrite = "SpecialKey"}) do
        vim.api.nvim_set_hl(0, hlgroup, a.merge(vim.api.nvim_get_hl_by_name(base_group, true), {italic = true, foreground = "#6c71c4", background = "NONE"}))
      end
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight", {clear = true})
      local function _18_()
        return vim.lsp.buf.document_highlight()
      end
      vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {group = group, pattern = "<buffer>", callback = _18_})
      local function _19_()
        return vim.lsp.buf.clear_references()
      end
      vim.api.nvim_create_autocmd({"CursorMoved"}, {group = group, pattern = "<buffer>", callback = _19_})
    else
    end
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "<buffer>", callback = vim.lsp.buf.format})
    else
    end
    return print("LSP Client Attached.")
  end
  local function _22_(server_name)
    vim.lsp.config(server_name, {capabilities = caps, on_attach = on_attach})
    return vim.lsp.enable(server_name)
  end
  return mlsp.setup_handlers({_22_})
end
local function _23_()
  return vim.lsp.buf.code_action()
end
return {{"folke/lsp-colors.nvim"}, {"williamboman/mason.nvim", opts = {}, tag = "v1.11.0"}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, opts = {ensure_installed = lsps, automatic_installation = true}, tag = "v1.32.0"}, {"neovim/nvim-lspconfig", config = _12_, dependencies = {"williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", "stevearc/conform.nvim", "Olical/nfnl"}, keys = {{"<leader>ca", _23_, desc = "Invoke code_action, prompting for an action to take at the cursor"}, {"<leader>fa", vim.lsp.buf.format, desc = "LSP format"}, {"<leader>rn", vim.lsp.buf.rename, desc = "LSP rename"}, {"gd", vim.lsp.buf.definition, desc = "Go to Definition"}, {"gD", vim.lsp.buf.declaration, desc = "Go to Declaration"}, {"gi", vim.lsp.buf.implementation, desc = "Go to Implementation"}, {"gr", vim.lsp.buf.references, desc = "Show References"}, {"K", vim.lsp.buf.hover, desc = "LSP Hover"}, {"[g", vim.lsp.diagnostic.goto_prev, desc = "Previous Diagnostic"}, {"]g", vim.lsp.diagnostic.goto_next, desc = "Next Diagnostic"}, {"<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help"}}, lazy = false}, {"RubixDev/mason-update-all", cmd = "MasonUpdateAll", dependencies = {"williamboman/mason.nvim", "Olical/nfnl"}, main = "mason-update-all", opts = {}}}
