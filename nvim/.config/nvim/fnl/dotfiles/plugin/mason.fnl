(module dotfiles.plugin.mason
        {autoload {nvim aniseed.nvim mason mason mason-lspconf mason-lspconfig}})

(mason.setup {:ui {:icons {:package_installed "✓"}}})

(mason-lspconf.setup {:ensure_installed [:lua_ls]})
