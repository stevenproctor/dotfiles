-- Source init.vim for migration of vimrc to neovim
vim.fn.sign_define("LspDiagnosticsSignError",
                   {texthl = "LspDiagnosticsSignError", text = "☢️", numhl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
                   {texthl = "LspDiagnosticsSignWarning", text = "⚠️", numhl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignHint",
                   {texthl = "LspDiagnosticsSignHint", text = "🔎", numhl = "LspDiagnosticsSignHint"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
                   {texthl = "LspDiagnosticsSignInformation", text = "ℹ️", numhl = "LspDiagnosticsSignInformation"})

local nvim_lsp = require('lspconfig')

function LspExecuteCommand(cmd, ...)
  arguments = {vim.uri_from_bufnr(0), vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[2] -1}
  for _,a in pairs({...}) do table.insert(arguments, a) end
  vim.lsp.buf.execute_command({command = cmd, arguments = arguments})
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  buf_set_keymap('n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>cn', "<cmd>lua LspExecuteCommand('clean-ns')<CR>", opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>ref', "<cmd>lua LspExecuteCommand('extract-function', vim.api.nvim_eval(\"input('Function name: ')\"))<CR>", opts)
  buf_set_keymap('x', '<leader>ref', "<cmd>lua LspExecuteCommand('extract-function', vim.api.nvim_eval(\"input('Function name: ')\"))<CR>", opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>fa', "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  buf_set_keymap('x', '<leader>fa', "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  buf_set_keymap('n', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  buf_set_keymap('x', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  buf_set_keymap('n', '<leader>id', "<cmd>lua LspExecuteCommand('inline-symbol')<CR>", opts)
  buf_set_keymap('x', '<leader>id', "<cmd>lua LspExecuteCommand('inline-symbol')<CR>", opts)
  buf_set_keymap('n', '<leader>il', "<cmd>lua LspExecuteCommand('introduce-let', vim.api.nvim_eval(\"input('Binding name: ')\"))<CR>", opts)
  buf_set_keymap('x', '<leader>il', "<cmd>lua LspExecuteCommand('introduce-let', vim.api.nvim_eval(\"input('Binding name: ')\"))<CR>", opts)
  buf_set_keymap('n', '<leader>m2l', "<cmd>lua LspExecuteCommand('move-to-let', vim.api.nvim_eval(\"input('Binding name: ')\"))<CR>", opts)
  buf_set_keymap('x', '<leader>m2l', "<cmd>lua LspExecuteCommand('move-to-let', vim.api.nvim_eval(\"input('Binding name: ')\"))<CR>", opts)

  vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
  -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), 'workspace/executeCommand', {command = 'clean-ns', arguments = {vim.uri_from_bufnr(0), vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[2]}, title = 'Clean Namespace'})]]

  vim.api.nvim_command[[lua print("Lsp Client Attached.")]]
end


-- vim.api.nvim_set_keymap('n', '<leader>li', '<Cmd>LspInfo<CR>', { noremap=true, silent=true })


local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end


-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--   -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
--   -- highlight = {
--   --   enable = true,              -- false will disable the whole extension
--   --   disable = { "c", "rust" },  -- list of language that will be disabled
--   --   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--   --   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--   --   -- Using this option may slow down your editor, and you may see some duplicate highlights.
--   --   -- Instead of true it can also be a list of languages
--   --   additional_vim_regex_highlighting = false,
--   -- },
-- }
--
--
vim.g["aniseed#env"] = { module = "my_nvim.init" }
