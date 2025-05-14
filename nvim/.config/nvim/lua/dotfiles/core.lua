-- [nfnl] fnl/dotfiles/core.fnl
local a = require("nfnl.core")
local u = require("dotfiles.util")
vim.cmd.set("shortmess+=c")
vim.cmd.set("path+=**")
vim.cmd.set("wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*")
local function safe_source(filename)
  local glob = vim.fn.glob(filename)
  if not a["empty?"](glob) then
    return vim.fn.source(filename)
  else
    return nil
  end
end
local backup_dir = (vim.fn.glob("$HOME") .. "/.vim/backup")
local undo_dir = (vim.fn.glob("$HOME") .. "/.vim/backup")
local on_opts = {"autoindent", "autoread", "expandtab", "exrc", "hlsearch", "ignorecase", "incsearch", "number", "ruler", "secure", "shiftround", "showcmd", "showmatch", "smartcase", "splitbelow", "splitright", "termguicolors", "title", "undofile", "wildmenu"}
local val_based_opts = {laststatus = 2, encoding = "utf-8", history = 500, redrawtime = 5000, scrolloff = 3, guifont = "Hasklig", guifontwide = "Hasklig", background = "dark", backupdir = backup_dir, directory = backup_dir, grepprg = "ag --vimgrep", tags = "tags", updatetime = 300, signcolumn = "auto:1-3", colorcolumn = {81, 100}, cmdheight = 2, undodir = undo_dir, undolevels = 1000, undoreload = 10000, foldmethod = "expr", foldexpr = "nvim_treesitter#foldexpr()", foldlevelstart = 100, foldlevel = 99, tabstop = 2, shiftwidth = 2, softtabstop = 2, mouse = "", list = true, listchars = "tab:\226\158\165\\ ,trail:\194\183,nbsp:\226\150\160", backspace = "indent,eol,start", wildmode = "list:longest,list:full", wrap = false}
local append_val_opts = {diffopt = "algorithm:patience"}
local function set_opt(_2_)
  local opt = _2_[1]
  local val = _2_[2]
  vim.opt[a.str(opt)] = val
  return nil
end
local function set_opt_2b(_3_)
  local opt = _3_[1]
  local val = _3_[2]
  local existing_opt_val = a.get(vim.o, opt)
  vim.opt[a.str(opt)] = a.str(existing_opt_val, ",", val)
  return nil
end
local function set_opt_on(opt)
  return set_opt({opt, true})
end
a.map(set_opt_on, on_opts)
a["map-indexed"](set_opt, val_based_opts)
a["map-indexed"](set_opt_2b, append_val_opts)
vim.cmd.syntax("on")
vim.cmd.colorscheme("solarized8")
vim.api.nvim_create_autocmd({"vimenter"}, {pattern = "*", command = "colorscheme solarized8", nested = true})
local function make_fennel_scratch()
  return vim.cmd("new | setlocal bt=nofile bh=wipe nobl noswapfile nu filetype=fennel")
end
vim.api.nvim_create_user_command("FennelScratchBuffer", make_fennel_scratch, {})
return u.nnoremap("<leader>fsb", ":call FennelScratchBuffer ()<CR>")
