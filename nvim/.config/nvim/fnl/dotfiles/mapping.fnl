(module dotfiles.mapping
        {autoload {nvim aniseed.nvim
                   nu aniseed.nvim.util
                   core aniseed.core
                   util dotfiles.util}})

(defn- noremap [mode from to] "Sets a mapping with {:noremap true}."
       (nvim.set_keymap mode from to {:noremap true}))

; (set nvim.g.mapleader "\\")

(defn aniseed-reload []
      (each [k _ (ipairs package.loaded)]
        (when (string.match k "^dotfiles%..+")
          (tset package.loaded k nil)))
      ((. (require :aniseed.env) :init) {:module :dotfiles.init :compile true})
      (core.println "aniseed reloaded!"))

(vim.keymap.set :n "<leader>`" aniseed-reload)

; (noremap :n "<leader>`" ":source ~/.config/nvim/init.lua<CR>")
(noremap :n :<leader>! ":call AniseedCompile()<CR>")

(noremap :n :<Enter> ":nohlsearch<Enter>/<BS>")

;; Correct to first spelling suggestion.
(noremap :n :<leader>zz ":normal! 1z=<cr>")

;; nice paste from clipboard in insert mode
(noremap :i :<C-V><C-O> ":set paste<CR><C-R><C-R>+<C-O>:set nopaste<CR>")

; Insert Date
(noremap :n :<F5> "\"=strftime(\"%F\")<CR>p")
(noremap :i :<F5> "<C-R>=strftime(\"%F\")<CR>")
(noremap :n :<M-5> "\"=trim(system('date -u'))<CR>p")
(noremap :i :<M-5> "<C-R>=trim(system('date -u'))<CR>")

; Make markdown link with empty url
;map <Leader>ah S<a href="" target="_blank" rel="noopener noreferrer"><CR>
(noremap :v :<leader>ah
         "S<a href=\"\" target=\"_blank\" rel=\"nopener noreferrer\"><CR>")

(noremap :v :<leader>ml "xi[<c-r>\"]()<esc>")

(noremap :n :<C-e> :3<C-e>)
(noremap :n :<C-y> :3<C-y>)

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
(noremap :n :<leader>mv ":AsyncRun -mode=bang open -a Marked\\ 2.app '%:p'<cr>")

; Run current statement in DadBod-UI
(nvim.ex.autocmd :FileType :sql :nmap :<leader>s :vap<leader>S)

(noremap :n :Q ":.!bash <CR>")

; Ruby old hash syntax to new hash syntax
;(util/lvnoremap :uhs "<C-U>s/\\([a-z][^ \\t]*\\) =>/\\1:/ge" )
;(util/lnnoremap :uhs "<C-U>s/\\([a-z][^ \\t]*\\) =>/\\1:/ge" )

; Trim trailing Whitespace in visual selection
(util.lvnoremap :tw "<C-U>s/\\s\\+$//ge<CR>:nohlsearch<Enter>/<BS>")

; Trim trailing Whitespace in current line
(util.lnnoremap :tw "<C-U>.s/\\s\\+$//ge<CR>:nohlsearch<Enter>/<BS>")

;; (noremap :n :<C-A-l> ":echo \"test\"\n")
; Window switching
; ˙ -> alt-h
; ∆ -> alt-j
; ˚ -> alt-k
; ¬ -> alt-l
;; Terminal mode
;; (noremap :t "˙" "<c-\\><c-n><c-w>h")
;; (noremap :t "∆" "<c-\\><c-n><c-w>j")
;; (noremap :t "˚" "<c-\\><c-n><c-w>k")
;; (noremap :t "¬" "<c-\\><c-n><c-w>l")
;; ;; Insert mode:
;; (noremap :i "˙" :<Esc><c-w>h)
;; (noremap :i "∆" :<Esc><c-w>j)
;; (noremap :i "˚" :<Esc><c-w>k)
;; (noremap :i "¬" :<Esc><c-w>l)
;; ;; Visual mode:
;; (noremap :v "˙" :<Esc><c-w>h)
;; (noremap :v "∆" :<Esc><c-w>j)
;; (noremap :v "˚" :<Esc><c-w>k)
;; (noremap :v "¬" :<Esc><c-w>l)
;; ;; Normal mode:
;; (noremap :n "˙" :<c-w>h)
;; (noremap :n "∆" :<c-w>j)
;; (noremap :n "˚" :<c-w>k)
;; (noremap :n "¬" :<c-w>l)
