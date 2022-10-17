(module dotfiles.plugin.luasnip
        {autoload {nvim aniseed.nvim util dotfiles.util luasnip luasnip}
         require {select_choice luasnip.extras.select_choice}})

(vim.keymap.set [:i :s] :<C-k>
                (fn []
                  (if (luasnip.expand_or_jumpable)
                      (luasnip.expand_or_jump))) {:silent true})

(vim.keymap.set [:i :s] :<C-j>
                (fn []
                  (if (luasnip.jumpable -1)
                      (luasnip.jump -1))) {:silent true})

(vim.keymap.set :i :<C-l> (fn []
                            (if (luasnip.choice_active)
                                (luasnip.choice 1))))

(vim.keymap.set :i :<C-u> select_choice)
