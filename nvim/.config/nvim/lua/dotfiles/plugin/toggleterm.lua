-- [nfnl] fnl/dotfiles/plugin/toggleterm.fnl
local toggleterm = require("toggleterm")
toggleterm.setup({open_mapping = "<c-\\>", start_in_insert = true, insert_mappings = true, terminal_mappings = true, persist_size = true, persist_mode = true, autochdir = true})
local function set_terminal_keymaps()
  vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
  vim.keymap.set("t", "jk", "<C-\\><C-n>")
  vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<CR>")
  vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<CR>")
  vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<CR>")
  vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<CR>")
  return vim.keymap.set("t", "<C-w>", "<C-\\><C-n><C-w>")
end
vim.api.nvim_create_user_command("SetTerminalKeymaps", set_terminal_keymaps, {})
return vim.api.nvim_create_autocmd({"TermOpen"}, {pattern = "term://*", callback = set_terminal_keymaps})
