(module dotfiles.terraform-helpers {require {nvim aniseed.nvim}})

(fn append-to-buf [bufno lines]
  (when lines
    (nvim.buf_set_lines buffno -1 -1 false lines)))

(var tf-log-bufno nil)

(fn terraform-import []
  (vim.fn.jobstart [:terraform :import :-no-color address id]
                   {:stdout_buffered true
                    :on_stdout (fn [_ data]
                                 (append-to-buf bufno data))}))

; (nu.fn-bridge :ZoomToggle :dotfiles.zoom-toggle :zoom-toggle {:return false})
; (u.nnoremap :<C-W>z ":call ZoomToggle()<CR>")
