-- [nfnl] fnl/dotfiles/plugins.fnl
local packer = require("packer")
local core = require("nfnl.core")
local function safe_require_plugin_config(name)
  local ok_3f, val_or_err = pcall(require, ("dotfiles.plugin." .. name))
  if not ok_3f then
    return print(("dotfiles error: " .. val_or_err))
  else
    return nil
  end
end
local function use(pkgs)
  local function _2_(use0)
    for name, opts in pairs(pkgs) do
      do
        local tmp_3_ = opts.mod
        if (nil ~= tmp_3_) then
          safe_require_plugin_config(tmp_3_)
        else
        end
      end
      use0(core.assoc(opts, 1, name))
    end
    return nil
  end
  return packer.startup(_2_)
end
local packages = {["Olical/nfnl"] = {}, ["Olical/conjure"] = {mod = "conjure"}, ["Olical/fennel.vim"] = {}, ["ahmedkhalf/project.nvim"] = {}, ["airblade/vim-gitgutter"] = {}, ["akinsho/toggleterm.nvim"] = {mod = "toggleterm"}, ["clojure-vim/vim-jack-in"] = {}, ["christianrondeau/vim-base64"] = {}, ["dhruvasagar/vim-table-mode"] = {}, ["folke/lsp-colors.nvim"] = {}, ["folke/which-key.nvim"] = {mod = "whichkey"}, ["gbprod/yanky.nvim"] = {mod = "yanky"}, ["hashivim/vim-terraform"] = {}, ["HiPhish/rainbow-delimiters.nvim"] = {}, ["hrsh7th/nvim-cmp"] = {requires = {"hrsh7th/cmp-buffer", "hrsh7th/cmp-emoji", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-path", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip-integ", "L3MON4D3/LuaSnip", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip"}, mod = "cmp"}, ["hrsh7th/vim-vsnip"] = {}, ["hrsh7th/vim-vsnip-integ"] = {}, ["Iron-E/nvim-soluarized"] = {}, ["jiangmiao/auto-pairs"] = {}, ["nvimtools/none-ls.nvim"] = {mod = "null-ls", requires = {"nvim-lua/plenary.nvim"}}, ["junegunn/vim-easy-align"] = {mod = "easyalign"}, ["kovisoft/paredit"] = {mod = "paredit", require = {"nvim-treesitter/nvim-treesitter"}}, ["kristijanhusak/vim-dadbod-completion"] = {}, ["kristijanhusak/vim-dadbod-ui"] = {}, ["L3MON4D3/LuaSnip"] = {mod = "luasnip"}, ["lifepillar/vim-solarized8"] = {}, ["lukas-reineke/headlines.nvim"] = {mod = "headlines"}, ["mrjones2014/smart-splits.nvim"] = {mod = "smartsplits"}, ["mechatroner/rainbow_csv"] = {}, ["MunifTanjim/nui.nvim"] = {}, ["neovim/nvim-lspconfig"] = {mod = "lspconfig"}, ["norcalli/nvim-colorizer.lua"] = {mod = "colorizer"}, ["nvim-neo-tree/neo-tree.nvim"] = {branch = "v3.x", require = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"}}, ["nvim-orgmode/orgmode"] = {mod = "orgmode"}, ["nvim-telescope/telescope.nvim"] = {requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}, mod = "telescope"}, ["nvim-tree/nvim-web-devicons"] = {}, ["nvim-treesitter/nvim-treesitter"] = {run = ":TSUpdate", mod = "treesitter"}, ["nvim-treesitter/playground"] = {}, ["radenling/vim-dispatch-neovim"] = {}, ["RaafatTurki/hex.nvim"] = {mod = "hex"}, ["rafamadriz/friendly-snippets"] = {}, ["skywind3000/asyncrun.vim"] = {}, ["tpope/vim-dadbod"] = {}, ["tpope/vim-dispatch"] = {}, ["tpope/vim-fugitive"] = {mod = "fugitive"}, ["tpope/vim-git"] = {}, ["tpope/vim-pathogen"] = {}, ["tpope/vim-rails"] = {}, ["tpope/vim-repeat"] = {}, ["tpope/vim-rhubarb"] = {}, ["tpope/vim-surround"] = {}, ["tpope/vim-unimpaired"] = {}, ["tpope/vim-vinegar"] = {}, ["wbthomason/packer.nvim"] = {mod = "packer"}, ["williamboman/mason.nvim"] = {mod = "mason", requires = {"williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig"}}}
return use(packages)
