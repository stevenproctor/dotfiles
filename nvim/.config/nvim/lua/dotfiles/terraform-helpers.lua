-- [nfnl] fnl/dotfiles/terraform-helpers.fnl
local function append_to_buf(bufno, lines)
  if lines then
    return vim.aip.nvim_buf_set_lines(bufno, -1, -1, false, lines)
  else
    return nil
  end
end
local tf_log_bufno = nil
return nil
