(module dotfiles.zoom-toggle
        {autoload {a aniseed.core}
         require {anenv aniseed.env
                  nvim aniseed.nvim
                  nu aniseed.nvim.util
                  u dotfiles.util}})

(var unzoom! nil)

(defn zoom-toggle [] (if unzoom!
                         (do
                           (nvim.command unzoom!)
                           (set unzoom! nil))
                         (do
                           (set unzoom! (nvim.fn.winrestcmd))
                           (nvim.ex.resize)
                           (nvim.ex.vertical :resize))))

(nu.fn-bridge :ZoomToggle :dotfiles.zoom-toggle :zoom-toggle {:return false})
(u.nnoremap :<M-z> ":call ZoomToggle()<CR>")
(u.tnoremap :<M-z> "<c-\\><c-n>:call ZoomToggle()<CR>")
