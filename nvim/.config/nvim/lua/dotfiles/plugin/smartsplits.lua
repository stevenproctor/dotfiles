-- [nfnl] fnl/dotfiles/plugin/smartsplits.fnl
local smart_splits = require("smart-splits")
if smart_splits then
  smart_splits.setup()
  vim.keymap.set("n", "<M-S-h>", smart_splits.resize_left)
  vim.keymap.set("n", "<M-S-j>", smart_splits.resize_down)
  vim.keymap.set("n", "<M-S-k>", smart_splits.resize_up)
  vim.keymap.set("n", "<M-S-l>", smart_splits.resize_right)
  vim.keymap.set("n", "<M-h>", smart_splits.move_cursor_left)
  vim.keymap.set("n", "<M-j>", smart_splits.move_cursor_down)
  vim.keymap.set("n", "<M-k>", smart_splits.move_cursor_up)
  vim.keymap.set("n", "<M-l>", smart_splits.move_cursor_right)
  vim.keymap.set("n", "<leader><leader>h", smart_splits.swap_buf_left)
  vim.keymap.set("n", "<leader><leader>j", smart_splits.swap_buf_down)
  vim.keymap.set("n", "<leader><leader>k", smart_splits.swap_buf_up)
  return vim.keymap.set("n", "<leader><leader>l", smart_splits.swap_buf_right)
else
  return nil
end
