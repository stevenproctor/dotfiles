(let [luasnip (require :luasnip)
      select_choice (require :luasnip.extras.select_choice)]
  (when luasnip
    (vim.keymap.set [:i :s] :<C-k>
                    (fn []
                      (if (luasnip.expand_or_jumpable)
                          (luasnip.expand_or_jump)))
                    {:silent true})
    (vim.keymap.set [:i :s] :<C-j>
                    (fn []
                      (if (luasnip.jumpable -1)
                          (luasnip.jump -1))) {:silent true})
    (vim.keymap.set :i :<C-l>
                    (fn []
                      (if (luasnip.choice_active)
                          (luasnip.choice 1))))
    (vim.keymap.set :i :<C-u> select_choice)))
