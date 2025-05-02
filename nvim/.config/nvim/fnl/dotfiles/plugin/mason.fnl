(local mason (require :mason))
(local mason-lspconf (require :mason-lspconfig) )
(local lspconfig (require :dotfiles.plugin.lspconfig))

(local a (require :aniseed.core))

(fn setup []
    (mason.setup {:ui {:icons {:package_installed "✓"}}})
    (when mason-lspconf
      (mason-lspconf.setup {:ensure_installed [:lua_ls]})
      (mason-lspconf.setup_handlers [lspconfig.default-server-handler])))

(setup)
;; (mason.setup)
;; 
;; (when-let [mason-lspconfig (require :mason-lspconfig)]
;;   (mason-lspconfig.setup)
;;           (mason-lspconfig.setup_handlers {1 default-server-handler}))
