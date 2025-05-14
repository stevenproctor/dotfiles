-- [nfnl] fnl/dotfiles/plugin/orgbullets.fnl
local core = require("nfnl.core")
local conceal = require("dotfiles.conceal")
local ts_utils = require("dotfiles.ts-utils")
local stars = {"\226\151\137", "\226\166\190", "\226\151\139", "\226\156\184", "\226\156\191", "\226\156\182", "\226\128\162", "\226\128\163"}
local stars_query = "(headline (stars) @stars)"
local function star_index(heading_level)
  local star_count = core.count(stars)
  local idx = math.fmod(heading_level, star_count)
  if (0 < idx) then
    return idx
  else
    return star_count
  end
end
local extmark_namespace = vim.api.nvim_create_namespace("HeaderStars")
local star_captures = ts_utils["make-query"]("org", stars_query)
local function gen_star_extmarks()
  if ("org" == vim.bo.filetype) then
    local bufnr = vim.api.nvim_get_current_buf()
    local star_count = core.count(stars)
    vim.api.nvim_buf_clear_namespace(bufnr, extmark_namespace, 0, -1)
    for id, node, metadata in star_captures(bufnr) do
      local start_line,start_col,end_row,end_col = node:range()
      local heading_level
      if (start_line == end_row) then
        heading_level = (end_col - start_col)
      else
        heading_level = nil
      end
      local star = core.get(stars, star_index(heading_level))
      local replacement = string.format(core.str("%", (2 + heading_level), "s"), star)
      vim.api.nvim_buf_set_extmark(bufnr, extmark_namespace, start_line, start_col, {end_col = end_col, end_row = end_row, virt_text = {{replacement, {}}}, virt_text_pos = "overlay", hl_mode = "combine"})
    end
    return nil
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("HeaderStars", {clear = true})
return vim.api.nvim_create_autocmd({"FileChangedShellPost", "Syntax", "TextChanged", "InsertLeave", "WinScrolled"}, {group = group, callback = conceal["setup-conceals"]})
