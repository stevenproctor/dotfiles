(module dotfiles.plugin.smartsplits
        {autoload {nvim aniseed.nvim
                   a aniseed.core
                   smart-splits smart-splits
                   ;; util dotfiles.util
                   }})

(smart-splits.setup)

;; recommended mappings
;; resizing splits
;; these keymaps will also accept a range,
;; for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
(vim.keymap.set :n :<M-S-h> smart-splits.resize_left)
(vim.keymap.set :n :<M-S-j> smart-splits.resize_down)
(vim.keymap.set :n :<M-S-k> smart-splits.resize_up)
(vim.keymap.set :n :<M-S-l> smart-splits.resize_right)
;; moving between splits
(vim.keymap.set :n :<M-h> smart-splits.move_cursor_left)
(vim.keymap.set :n :<M-j> smart-splits.move_cursor_down)
(vim.keymap.set :n :<M-k> smart-splits.move_cursor_up)
(vim.keymap.set :n :<M-l> smart-splits.move_cursor_right)
;; swapping buffers between windows
(vim.keymap.set :n :<leader><leader>h smart-splits.swap_buf_left)
(vim.keymap.set :n :<leader><leader>j smart-splits.swap_buf_down)
(vim.keymap.set :n :<leader><leader>k smart-splits.swap_buf_up)
(vim.keymap.set :n :<leader><leader>l smart-splits.swap_buf_right)
