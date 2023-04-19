(module dotfiles.plugin.mason
        {autoload {a aniseed.core
                   nvim aniseed.nvim mason mason mason-lspconf mason-lspconfig}})

(defn setup []
  (when mason
    (mason.setup {:ui {:icons {:package_installed "✓"}}})
    (when mason-lspconf
      (mason-lspconf.setup {:ensure_installed [:lua_ls]})
      (mason-lspconf.setup_handlers {1 default-server-handler}))))
