local execute = vim.api.nvim_command
local fn = vim.fn

local pack_path = fn.stdpath("data") .. "/site/pack"
local fmt = string.format

function ensure (user, repo)
  -- Ensures a given github.com/USER/REPO is cloned in the pack/packer/start directory.
  local install_path = fmt("%s/packer/start/%s", pack_path, repo, repo)
  if fn.empty(fn.glob(install_path)) > 0 then
    execute(fmt("!git clone https://github.com/%s/%s %s", user, repo, install_path))
    execute(fmt("packadd %s", repo))
  end
end

-- Bootstrap essential plugins required for installing and loading the rest.
ensure("wbthomason", "packer.nvim")
ensure("Olical", "aniseed")

-- Enable Aniseed's automatic compilation and loading of Fennel source code.
vim.g["aniseed#env"] = {
  module = "dotfiles.init",
  compile = true
}

-- -- require'nvim-treesitter.configs'.setup {
-- --   ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
-- --   -- ignore_install = { "javascript" }, -- List of parsers to ignore installing
-- --   -- highlight = {
-- --   --   enable = true,              -- false will disable the whole extension
-- --   --   disable = { "c", "rust" },  -- list of language that will be disabled
-- --   --   -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
-- --   --   -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
-- --   --   -- Using this option may slow down your editor, and you may see some duplicate highlights.
-- --   --   -- Instead of true it can also be a list of languages
-- --   --   additional_vim_regex_highlighting = false,
-- --   -- },
-- -- }
-- --
-- --
-- --
