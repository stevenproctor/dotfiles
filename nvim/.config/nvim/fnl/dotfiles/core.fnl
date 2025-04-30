(local a (require :aniseed.core))
(local u (require :dotfiles.util))

(vim.cmd.set :shortmess+=c)

; don't give |ins-completion-menu| messages.
(vim.cmd.set :path+=**)
(vim.cmd.set "wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*")

(fn safe-source [filename]
  (let [glob (vim.fn.glob filename)]
    (if (not (a.empty? glob))
        (vim.fn.source filename))))

; (a.map safe-source ["~/.vimrc" "~/.vimrc.local"])

(local backup-dir (.. (vim.fn.glob :$HOME) :/.vim/backup))
(local undo-dir (.. (vim.fn.glob :$HOME) :/.vim/backup))

(local on-opts [:autoindent
                :autoread
                :expandtab
                :exrc
                ; allow project level (neo)vim files
                :hlsearch
                :ignorecase
                :incsearch
                :number
                :ruler
                :secure
                :shiftround
                ; When at 3 spaces and I hit >>, go to 4, not 5.
                :showcmd
                ; shows (parital) command in the status line
                :showmatch
                :smartcase
                :splitbelow
                :splitright
                :termguicolors
                :title
                :undofile
                :wildmenu])

(local val-based-opts {; :t_Co 256
                       :laststatus 2
                       :encoding :utf-8
                       :history 500
                       :redrawtime 5000
                       :scrolloff 3
                       :guifont :Hasklig
                       :guifontwide :Hasklig
                       :background :dark
                       :backupdir backup-dir
                       :directory backup-dir
                       ;Don't clutter my dirs up with swp and tmp files
                       :grepprg "ag --vimgrep"
                       ; Use Silver Searcher instead of grep
                       :tags :tags
                       :updatetime 300
                       ; per coc.vim for diagnostic messages
                       :signcolumn "auto:1-3"
                       :colorcolumn [81 100]
                       :cmdheight 2
                       ; Better display for messages
                       :undodir undo-dir
                       :undolevels 1000
                       :undoreload 10000
                       :foldmethod :expr
                       :foldexpr "nvim_treesitter#foldexpr()"
                       :foldlevelstart 100
                       :foldlevel 99
                       :tabstop 2
                       :shiftwidth 2
                       :softtabstop 2
                       :mouse ""
                       :list true
                       :listchars "tab:➥\\ ,trail:·,nbsp:■"
                       :backspace "indent,eol,start"
                       ;allow backspacing over everything in insert mode
                       :wildmode "list:longest,list:full"
                       :wrap false})

(local append-val-opts {:diffopt "algorithm:patience"})

(fn set-opt [[opt val]] (tset vim.opt (a.str opt) val))

(fn set-opt+ [[opt val]]
  (let [existing-opt-val (a.get vim.o opt)]
    (tset vim.opt (a.str opt) (a.str existing-opt-val "," val))))

(fn set-opt-on [opt] (set-opt [opt true]))

(a.map set-opt-on on-opts)

(a.map-indexed set-opt val-based-opts)

(a.map-indexed set-opt+ append-val-opts)

(vim.cmd.syntax :on)
;; (nvim.ex.colorscheme :soluarized)
(vim.cmd.colorscheme :solarized8)

;; (nvim.ex.autocmd "vimenter" "*" "++nested" "colorscheme" "soluarized")

(vim.api.nvim_create_autocmd [:vimenter]
                             {:pattern "*"
                              :command "colorscheme solarized8"
                              :nested true})

;(nvim.ex.autocmd "vimenter" "*"  "luafile" "treesitter.lua")
;
; (nvim.fn.glob "~/.vimrc.local")

(fn make-fennel-scratch []
  (vim.cmd "new | setlocal bt=nofile bh=wipe nobl noswapfile nu filetype=fennel"))

(vim.api.nvim_create_user_command :FennelScratchBuffer make-fennel-scratch {})

(u.nnoremap :<leader>fsb ":call FennelScratchBuffer ()<CR>")

;; (fn compile-fnl [] (print :recompiling)
;;   (anenv.init {:force true :init :dotfiles.init}))
;; 
;; (vim.api.nvim_create_user_command :AniseedCompile compile-fnl {})
