-- [nfnl] fnl/dotfiles/conceal.fnl
local u = require("dotfiles.util")
local conceals = {defn = "\240\157\145\147", fn = "\206\187", lambda = "\206\187", ["and"] = "\226\136\167", ["&&"] = "\226\136\167", ["or"] = "\226\136\168", ["||"] = "\226\136\168", ["not"] = "\194\172", ["!"] = "\194\172", ["for"] = "\226\136\128", ["in"] = "\226\136\136", ["true"] = "\226\138\164", ["false"] = "\226\138\165"}
local function setup_conceals()
  vim.fn.clearmatches()
  for the_match, replacement in pairs(conceals) do
    local the_match0 = ("\\<" .. the_match .. "\\>")
    vim.fn.matchadd("Conceal", the_match0, 0, -1, {conceal = replacement})
  end
  vim.wo.conceallevel = 2
  vim.wo.concealcursor = "nvc"
  return nil
end
local function toggle_conceal()
  if (0 == vim.wo.conceallevel) then
    vim.wo.conceallevel = 2
    return nil
  else
    vim.wo.conceallevel = 0
    return nil
  end
end
vim.api.nvim_create_user_command("ToggleConceal", toggle_conceal, {})
vim.api.nvim_create_user_command("SetupConceals", setup_conceals, {})
u.nnoremap("<leader>ts", "call ToggleConceal()")
local pretty_filetypes = {"fennel", "clojure"}
for _, ftype in pairs(pretty_filetypes) do
  vim.api.nvim_create_autocmd({"FileType"}, {pattern = ftype, callback = setup_conceals})
end
return {["setup-conceals"] = setup_conceals}
