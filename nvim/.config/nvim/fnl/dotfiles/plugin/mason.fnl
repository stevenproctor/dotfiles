(fn setup []
  (let [mason (require :mason)
        mason-lspconf (require :mason-lspconfig)
        lspconfig (require :dotfiles.plugin.lspconfig)]
    (when mason
      (mason.setup {:ui {:icons {:package_installed "✓"}}})
      (when mason-lspconf
        (mason-lspconf.setup {:ensure_installed [:lua_ls]})
        (mason-lspconf.setup_handlers {1 lspconfig.default-server-handler})))))

(setup)
