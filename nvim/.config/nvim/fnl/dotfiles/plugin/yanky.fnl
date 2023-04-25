(module dotfiles.plugin.yanky {autoload {nvim aniseed.nvim
                                         a aniseed.core
                                         ;; util dotfiles.util
                                         yanky yanky}
                               ;; require {minpac minpac}
                               })

(yanky.setup {:ring {:history_length 100
                     :storage :shada
                     :sync_with_numbered_registers true
                     :cancel_event :update}
              :system_clipboard {:sync_with_ring true}})

(vim.keymap.set :n :p "<Plug>(YankyPutAfter)")
(vim.keymap.set :n :P "<Plug>(YankyPutBefore)")
(vim.keymap.set :n :gp "<Plug>(YankyGPutAfter)")
(vim.keymap.set :n :gP "<Plug>(YankyGPutBefore)")
(vim.keymap.set :n :<c-n> "<Plug>(YankyCycleForward)")
(vim.keymap.set :n :<c-p> "<Plug>(YankyCycleBackward)")

(vim.keymap.set :n "]p" "<Plug>(YankyPutIndentAfterLinewise)")
(vim.keymap.set :n "[p" "<Plug>(YankyPutIndentBeforeLinewise)")
(vim.keymap.set :n "]P" "<Plug>(YankyPutIndentAfterLinewise)")
(vim.keymap.set :n "[P" "<Plug>(YankyPutIndentBeforeLinewise)")

(vim.keymap.set :n :>p "<Plug>(YankyPutIndentAfterShiftRight)")
(vim.keymap.set :n :<p "<Plug>(YankyPutIndentAfterShiftLeft)")
(vim.keymap.set :n :>P "<Plug>(YankyPutIndentBeforeShiftRight)")
(vim.keymap.set :n :<P "<Plug>(YankyPutIndentBeforeShiftLeft)")

(vim.keymap.set :n :=p "<Plug>(YankyPutAfterFilter)")
(vim.keymap.set :n :=P "<Plug>(YankyPutBeforeFilter)")

(vim.keymap.set :x :p "<Plug>(YankyPutAfter)")
(vim.keymap.set :x :P "<Plug>(YankyPutBefore)")
(vim.keymap.set :x :gp "<Plug>(YankyGPutAfter)")
(vim.keymap.set :x :gP "<Plug>(YankyGPutBefore)")
