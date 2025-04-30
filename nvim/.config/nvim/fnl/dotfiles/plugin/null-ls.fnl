(let [null-ls (require :null-ls)
      lspconfig (require :dotfiles.plugin.lspconfig)]
  (when null-ls
    (local null-ls-server-options
           {:sources [null-ls.builtins.formatting.stylua
                      null-ls.builtins.formatting.fnlfmt]
            :on_attach lspconfig.on_attach})
    (null-ls.setup null-ls-server-options)))
