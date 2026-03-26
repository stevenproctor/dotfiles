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
  local coll_types = {"map", "list", "set", "vector"}
  local a = require("nfnl.core")
  local choice
  local function _13_(_12_)
    local k = _12_[1]
    local v = _12_[2]
    return (tostring(k) .. ". " .. v)
  end
  choice = vim.fn.inputlist(a.concat({"Collection Type:"}, a["map-indexed"](_13_, coll_types)))
  return a.get(coll_types, choice)
end
client_command_lnmappings = {clojure_lsp = {ai = {"add-import-to-namespace", {_1_}}, am = {"add-missing-libspec", {}}, as = {"add-require-suggestion", {_2_, _3_, _4_}}, cc = {"cycle-coll", {}}, cn = {"clean-ns", {}}, cp = {"cycle-privacy", {}}, ct = {"create-test", {}}, df = {"drag-forward", {}}, db = {"drag-backward", {}}, dk = {"destructure-keys", {}}, ed = {"extract-to-def", {_5_}}, ref = {"extract-function", {_6_}}, el = {"expand-let", {}}, fe = {"create-function", {}}, il = {"introduce-let", {_7_}}, is = {"inline-symbol", {}}, ma = {"resolve-macro-as", {}}, mf = {"move-form", {_8_}}, ml = {"move-to-let", {_9_}}, pf = {"promote-fn", {_10_}}, sc = {"change-coll", {_11_}}, sm = {"sort-map", {}}, tf = {"thread-first-all", {}}, tF = {"thread-first", {}}, tl = {"thread-last-all", {}}, tL = {"thread-last", {}}, ua = {"unwind-all", {}}, uw = {"unwind-thread", {}}}}
local vim = _G.vim
local lsps = {"clojure_lsp", "lua_ls", "jsonls", "yamlls", "marksman", "html", "terraformls", "dockerls", "docker_compose_language_service", "bashls", "sqlls"}
local filetype__3eformatters = {lua = {"stylua"}, sh = {"shfmt"}, python = {"ruff_organize_imports", "ruff_format"}, rust = {"rustfmt"}, toml = {"taplo"}, json = {"prettierd"}, javascript = {"prettierd"}, typescript = {"prettierd"}, jsx = {"prettierd"}, html = {"prettierd"}, css = {"prettierd"}, yaml = {"prettierd"}, markdown = {"prettierd"}, fennel = {"fnlfmt"}, sql = {"sqlfmt"}, gleam = {"gleam"}, _ = {lsp_format = "prefer"}, ["*"] = {"trim_whitespace", "trim_newlines"}}
local formatter__3epackage = {ruff_organize_imports = "ruff", ruff_format = "ruff"}
local disable_formatter_on_save = {fennel = true, sql = true}
local disable_formatter_auto_install = {cljfmt = true, fnlfmt = true, rustfmt = true, trim_whitespace = true, trim_newlines = true, gleam = true}
vim.lsp.enable({"clojure", "fennel-ls", "typedclojure"})
local function _14_(_, opts)
  local conform = require("conform")
  local registry = require("mason-registry")
  local formatters_for_mason = {}
  conform.formatters.shfmt = {prepend_args = {"-i", "2", "-ci"}}
  local function _15_()
    for _ft, formatters in pairs(filetype__3eformatters) do
      for _idx, formatter in ipairs(formatters) do
        if not disable_formatter_auto_install[formatter] then
          formatters_for_mason[(formatter__3epackage[formatter] or formatter)] = true
        else
        end
      end
    end
    for formatter, _true in pairs(formatters_for_mason) do
      local pkg = registry.get_package(formatter)
      if not pkg:is_installed() then
        vim.notify(("Automatically installing " .. formatter .. " with Mason."))
        pkg:install()
      else
      end
    end
    return nil
  end
  vim.schedule(_15_)
  vim.g.dotfiles_format_on_save = true
  conform.setup(opts)
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  return nil
end
local function _18_()
  if (nil == vim.b.dotfiles_format_on_save) then
    vim.b.dotfiles_format_on_save = false
  else
    vim.b.dotfiles_format_on_save = not vim.b.dotfiles_format_on_save
  end
  return vim.notify(("Set vim.b.dotfiles_format_on_save to " .. tostring(vim.b.dotfiles_format_on_save)))
end
local function _20_()
  vim.g.dotfiles_format_on_save = not vim.g.dotfiles_format_on_save
  return vim.notify(("Set vim.g.dotfiles_format_on_save to " .. tostring(vim.g.dotfiles_format_on_save)))
end
local function _21_(_buf)
  if (vim.g.dotfiles_format_on_save and ((nil == vim.b.dotfiles_format_on_save) or vim.b.dotfiles_format_on_save) and not disable_formatter_on_save[vim.bo.filetype]) then
    return {timeout_ms = 500, lsp_format = "fallback"}
  else
    return nil
  end
end
local function _23_()
  local caps = require("cmp_nvim_lsp").default_capabilities()
  local mlsp = require("mason-lspconfig")
  local a = require("nfnl.core")
  local u = require("dotfiles.util")
  local lsp = require("vim.lsp")
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
        local function _25_()
          local opts
          do
            local s = ""
            for _i, opt in ipairs(a.second(command_mapping)) do
              local _26_
              if ("function" == type(opt)) then
                _26_ = opt()
              else
                _26_ = opt
              end
              s = (s .. _26_)
            end
            opts = s
          end
          return lsp_execute_command(client, lsp_cmd, opts)
        end
        cmd = _25_
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
      local function _29_()
        return vim.lsp.buf.document_highlight()
      end
      vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {group = group, pattern = "<buffer>", callback = _29_})
      local function _30_()
        return vim.lsp.buf.clear_references()
      end
      vim.api.nvim_create_autocmd({"CursorMoved"}, {group = group, pattern = "<buffer>", callback = _30_})
    else
    end
    if client.server_capabilities.documentFormattingProvider then
      local function _32_()
        return require("conform").format()
      end
      vim.api.nvim_create_autocmd({"BufWritePre"}, {pattern = "<buffer>", callback = _32_})
    else
    end
    return print("LSP Client Attached.")
  end
  local function _34_(server_name)
    vim.lsp.config(server_name, {capabilities = caps, on_attach = on_attach})
    return vim.lsp.enable(server_name)
  end
  return mlsp.setup_handlers({_34_})
end
local function _35_()
  return vim.lsp.buf.code_action()
end
local function _36_()
  return require("conform").format()
end
return {{"folke/lsp-colors.nvim"}, {"williamboman/mason.nvim", opts = {}, tag = "v1.11.0"}, {"stevearc/conform.nvim", config = _14_, dependencies = {"rcarriga/nvim-notify"}, keys = {{"<leader>tbf", _18_, desc = "Toggle buffer formatting"}, {"<leader>tgf", _20_, desc = "Toggle global formatting"}}, opts = {formatters_by_ft = filetype__3eformatters, format_on_save = _21_}}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, opts = {ensure_installed = lsps, automatic_installation = true}, tag = "v1.32.0"}, {"neovim/nvim-lspconfig", config = _23_, dependencies = {"williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", "stevearc/conform.nvim", "Olical/nfnl"}, keys = {{"<leader>ca", _35_, desc = "Invoke code_action, prompting for an action to take at the cursor"}, {"<leader>fa", _36_, desc = "LSP format"}, {"<leader>rn", vim.lsp.buf.rename, desc = "LSP rename"}, {"gd", vim.lsp.buf.definition, desc = "Go to Definition"}, {"gD", vim.lsp.buf.declaration, desc = "Go to Declaration"}, {"gi", vim.lsp.buf.implementation, desc = "Go to Implementation"}, {"gr", vim.lsp.buf.references, desc = "Show References"}, {"K", vim.lsp.buf.hover, desc = "LSP Hover"}, {"[g", vim.lsp.diagnostic.goto_prev, desc = "Previous Diagnostic"}, {"]g", vim.lsp.diagnostic.goto_next, desc = "Next Diagnostic"}, {"<c-k>", vim.lsp.buf.signature_help, desc = "Signature Help"}}, lazy = false}, {"RubixDev/mason-update-all", cmd = "MasonUpdateAll", dependencies = {"williamboman/mason.nvim", "Olical/nfnl"}, main = "mason-update-all", opts = {}}}
