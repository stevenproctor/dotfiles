(module dotfiles.mapping
  {autoload {nvim aniseed.nvim
             nu aniseed.nvim.util
             core aniseed.core}})

(defn- noremap [mode from to]
  "Sets a mapping with {:noremap true}."
  (nvim.set_keymap mode from to {:noremap true}))

; (set nvim.g.mapleader "\\")

(noremap :n "<leader>`" ":source ~/.config/nvim/init.lua<CR>")

(noremap :n :<Enter> ":nohlsearch<Enter>/<BS>")

;; Correct to first spelling suggestion.
(noremap :n :<leader>zz ":normal! 1z=<cr>")


;; nice paste from clipboard in insert mode
(noremap :i :<C-V><C-O> ":set paste<CR><C-R><C-R>+<C-O>:set nopaste<CR>")


; Insert Date
(noremap :n :<F5> "\"=strftime(\"%F\")<CR>p")
(noremap :i :<F5> "<C-R>=strftime(\"%F\")<CR>")

; Make markdown link with empty url
;map <Leader>ah S<a href="" target="_blank" rel="noopener noreferrer"><CR>
(noremap :v :<leader>ah "S<a href=\"\" target=\"_blank\" rel=\"nopener noreferrer\"><CR>")
(noremap :v :<leader>ml "xi[<c-r>\"]()<esc>")


(noremap :n :<C-e> "3<C-e>")
(noremap :n :<C-y> "3<C-y>")

; Unimpaired configuration
; Bubble single lines
(noremap :n :<C-k> "[e")
(noremap :n :<C-j> "]e")
; Bubble multiple lines
(noremap :v :<C-k> "[egv")
(noremap :v :<C-j> "]egv")

; Format JSON
(noremap :n :<leader>jpp ":%!python -m json.tool --indent=2<CR>")

; Map w!! to write readonly files
(noremap :c :w!! "w !sudo tee % >/dev/null")

(noremap :n :gnh ":GitGutterNextHunk<CR>")
(noremap :n :gph ":GitGutterPrevHunk<CR>")
(noremap :n :gsh ":GitGutterStageHunk<CR>")

; Open file in Marked 2 (markdown viewer)
(noremap :n :<leader>mv ":AsyncRun -mode=bang open -a Marked\\ 2.app \'%:p\'<cr>")
