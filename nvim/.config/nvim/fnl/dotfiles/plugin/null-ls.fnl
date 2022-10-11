(module dotfiles.plugin.null-ls
        {autoload {nvim aniseed.nvim
                   a aniseed.core
                   nu aniseed.nvim.util
                   null-ls null-ls
                   lspconfig dotfiles.plugin.lspconfig}})

(def null-ls-server-options
     {:sources [null-ls.builtins.formatting.stylua
                null-ls.builtins.formatting.fnlfmt]
      :on_attach lspconfig.on_attach})

(null-ls.setup null-ls-server-options)
