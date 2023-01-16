(module dotfiles.core {autoload {a aniseed.core}
                       require {anenv aniseed.env
                                nvim aniseed.nvim
                                nu aniseed.nvim.util
                                u dotfiles.util}})

(nvim.ex.set :shortmess+=c)

; don't give |ins-completion-menu| messages.
(nvim.ex.set :path+=**)
(nvim.ex.set "wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*")

(defn- safe-source [filename]
       (let [glob (nvim.fn.glob filename)]
         (if (not (a.empty? glob))
             (nvim.ex.source filename))))

; (a.map safe-source ["~/.vimrc" "~/.vimrc.local"])

(def- backup-dir (.. (nvim.fn.glob :$HOME) :/.vim/backup))
(def- undo-dir (.. (nvim.fn.glob :$HOME) :/.vim/backup))

(def- on-opts [:autoindent
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

(def- val-based-opts {; :t_Co 256
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
                      :colorcolumn [80 100]
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
                      :listchars "tab:➥\\ ,trail:·,"
                      :backspace "indent,eol,start"
                      ;allow backspacing over everything in insert mode
                      :wildmode "list:longest,list:full"
                      :wrap false})

(def- append-val-opts {:diffopt "algorithm:patience"})

(defn- set-opt [[opt val]] (tset vim.opt (a.str opt) val))

(defn- set-opt+ [[opt val]]
       (let [existing-opt-val (a.get nvim.o opt)]
         (tset vim.opt (a.str opt) (a.str existing-opt-val "," val))))

(defn- set-opt-on [opt] (set-opt [opt true]))

(a.map set-opt-on on-opts)

(a.map-indexed set-opt val-based-opts)

(a.map-indexed set-opt+ append-val-opts)

(nvim.ex.syntax :on)
;; (nvim.ex.colorscheme :soluarized)
(nvim.ex.colorscheme :solarized8)

;; (nvim.ex.autocmd "vimenter" "*" "++nested" "colorscheme" "soluarized")
(nvim.ex.autocmd :vimenter "*" :++nested :colorscheme :solarized8)
;(nvim.ex.autocmd "vimenter" "*"  "luafile" "treesitter.lua")
;
; (nvim.fn.glob "~/.vimrc.local")

(defn make-fennel-scratch []
      (nvim.command "new | setlocal bt=nofile bh=wipe nobl noswapfile nu filetype=fennel"))

(nu.fn-bridge :FennelScratchBuffer :dotfiles.core :make-fennel-scratch
              {:return false})

(u.nnoremap :<leader>fsb ":call FennelScratchBuffer ()<CR>")

(defn compile-fnl [] (print :recompiling)
      (anenv.init {:force true :init :dotfiles.init}))

(nu.fn-bridge :AniseedCompile :dotfiles.core :compile-fnl {:return false})
