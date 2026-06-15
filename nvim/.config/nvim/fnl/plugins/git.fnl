(import-macros {: tx} :config.macros)

(tx :NeogitOrg/neogit
    {:lazy true
     :dependencies [;; Only one of these is needed.
                    :esmuellert/codediff.nvim
                    ;      -- optional
                    ;"sindrets/diffview.nvim";        -- optional
                    ;; For a custom log pager
                    :m00qek/baleia.nvim
                    ;            -- optional
                    ;; Only one of these is needed.
                    :nvim-telescope/telescope.nvim
                    ; -- optional
                    ; "ibhagwan/fzf-lua";              -- optional
                    ; "nvim-mini/mini.pick";           -- optional
                    ; "folke/snacks.nvim";             -- optional
                    ]
     :cmd :Neogit
     :keys [(tx :<leader>gg :<cmd>Neogit<cr> {:desc "Show Neogit UI"})]})
