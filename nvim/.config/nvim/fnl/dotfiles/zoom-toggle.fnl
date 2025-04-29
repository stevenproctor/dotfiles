(local u (require :dotfiles.util))

(var unzoom! nil)

(fn zoom-toggle []
  (if unzoom!
      (do
        (vim.cmd unzoom!)
        (set unzoom! nil))
      (do
        (set unzoom! (vim.fn.winrestcmd))
        (vim.fn.resize)
        (vim.fn.vertical :resize))))

(vim.api.nvim_create_user_command :ZoomToggle zoom-toggle {})

(u.nnoremap :<M-z> ":call ZoomToggle()<CR>")
(u.tnoremap :<M-z> "<c-\\><c-n>:call ZoomToggle()<CR>")
