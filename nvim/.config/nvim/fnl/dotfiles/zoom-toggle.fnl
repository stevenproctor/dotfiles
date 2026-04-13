(import-macros {: tx} :config.macros)

(local u (require :dotfiles.util))

(var unzoom! nil)

(fn zoom-toggle []
  (if unzoom!
      (do
        (vim.cmd unzoom!)
        (set unzoom! nil))
      (do
        (set unzoom! (vim.fn.winrestcmd))
        (vim.cmd.resize)
        (vim.cmd.resize {:mods {:vertical true}}))))


(vim.api.nvim_create_user_command :ZoomToggle zoom-toggle {})

;; (u.nnoremap :<M-z> ":call ZoomToggle()<CR>")
;; (u.tnoremap :<M-z> "<c-\\><c-n>:call ZoomToggle()<CR>")

(let [wk (require :which-key)]
  (wk.add [[(tx :<M-z> zoom-toggle
                    {:desc "Toggle zoom of buffer window"})]
               [(tx :<M-z> zoom-toggle
                    {:desc "Toggle zoom of buffer window"
                     :mode [:n :t] })]] ))
