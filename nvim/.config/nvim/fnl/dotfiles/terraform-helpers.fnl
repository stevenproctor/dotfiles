(fn append-to-buf [bufno lines]
  (when lines
    (vim.aip.nvim_buf_set_lines bufno -1 -1 false lines)))

(var tf-log-bufno nil)

;; (fn terraform-import []
;;   (vim.fn.jobstart [:terraform :import :-no-color address id]
;;                    {:stdout_buffered true
;;                     :on_stdout (fn [_ data]
;;                                  (append-to-buf tf-log-bufno data))}))
;; 
; (nu.fn-bridge :ZoomToggle :dotfiles.zoom-toggle :zoom-toggle {:return false})
; (u.nnoremap :<C-W>z ":call ZoomToggle()<CR>")
