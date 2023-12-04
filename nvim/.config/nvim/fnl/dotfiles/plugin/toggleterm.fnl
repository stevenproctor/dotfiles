(module dotfiles.toggleterm
        {autoload {a aniseed.core}
         require {nvim aniseed.nvim
                  nu aniseed.nvim.util
                  toggleterm toggleterm}})

(toggleterm.setup {
  :open_mapping :<c-\>
  :start_in_insert true
  :insert_mappings true ;; whether or not the open mapping applies in insert mode
  :terminal_mappings true ;; whether or not the open mapping applies in the opened terminals
  :persist_size true
  :persist_mode true ;; if set to true (default) the previous terminal mode will be remembered
  })


(defn set_terminal_keymaps []
  (vim.keymap.set :t :<esc> :<C-\><C-n>)
  (vim.keymap.set :t :jk :<C-\><C-n>)
  (vim.keymap.set :t :<C-h> "<Cmd>wincmd h<CR>")
  (vim.keymap.set :t :<C-j> "<Cmd>wincmd j<CR>")
  (vim.keymap.set :t :<C-k> "<Cmd>wincmd k<CR>")
  (vim.keymap.set :t :<C-l> "<Cmd>wincmd l<CR>")
  (vim.keymap.set :t :<C-w> :<C-\><C-n><C-w>))


(nu.fn-bridge :SetTerminalKeymaps :dotfiles.toggleterm :set_terminal_keymaps {:return false})

(nvim.ex.autocmd :TermOpen "term://*" :call "SetTerminalKeymaps()")
