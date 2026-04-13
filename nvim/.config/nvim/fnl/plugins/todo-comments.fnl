(import-macros {: tx} :config.macros)

(tx :folke/todo-comments.nvim
    {:dependencies [:nvim-lua/plenary.nvim] :opts {:lazy false}})
