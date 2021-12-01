(module dotfiles.plugins
  {autoload {nvim aniseed.nvim
             a aniseed.core
             ;; util dotfiles.util
             packer packer

             }
   ;; require {minpac minpac}
   })


(defn safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. :dotfiles.plugin. name))]
    (when (not ok?)
      (print (.. "dotfiles error: " val-or-err)))))

(defn- use [pkgs]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well."
  (packer.startup
    (fn [use]
      (each [name opts (pairs pkgs)]
          (-?> (. opts :mod) (safe-require-plugin-config))
          (use (a.assoc opts 1 name))
        ))))


(def- packages
  {
   :Olical/aniseed {}
   :Olical/conjure { :mod :conjure } ; Clojure
   :Olical/fennel.vim {} ; Fennel
   :airblade/vim-gitgutter {} ; Git
   :airblade/vim-gitgutter {} ; Git
   :clojure-vim/vim-jack-in {} ; Conjure support - jack-in with nrepl dependencies
   :folke/lsp-colors.nvim {}
   :hashivim/vim-terraform {} ; Terraform
   :hrsh7th/nvim-compe {:mod :compe} ; autocomplete
   :jiangmiao/auto-pairs {} ; backets, parens, and quotes in pairs
   :junegunn/vim-easy-align {:mod :easyalign}
   :kovisoft/paredit {}
   :kristijanhusak/vim-dadbod-completion {}
   :kristijanhusak/vim-dadbod-ui {}
   :neovim/nvim-lspconfig {:mod :lspconfig} ; NeoVim  lsp config
   :norcalli/nvim-colorizer.lua {:mode :colorizer}
   :nvim-telescope/telescope.nvim {:requires [[:nvim-lua/popup.nvim] [:nvim-lua/plenary.nvim]] :mod :telescope}
   :nvim-treesitter/nvim-treesitter {:run ":TSUpdate" :mod :treesitter}
   :p00f/nvim-ts-rainbow {}
   :radenling/vim-dispatch-neovim {} ; Clojure
   :skywind3000/asyncrun.vim {} ; :AsyncRun
   :tami5/compe-conjure {} ; autocomplete using conjure as a source
   :tpope/vim-classpath {}
   :tpope/vim-dadbod {}
   :tpope/vim-dispatch {} ; Conjure support - jack-in with nrepl dependencies
   :tpope/vim-fugitive {} ; Git
   :tpope/vim-git {} ; Git Commit Message
   :tpope/vim-pathogen {}
   :tpope/vim-rails {}
   :tpope/vim-repeat {}
   :tpope/vim-surround {}
   :tpope/vim-unimpaired {}
   :tpope/vim-vinegar {}
   :wbthomason/packer.nvim {:mod :packer}
   :williamboman/nvim-lsp-installer {} ; NeoVim lsp server installs

   ; :luochen1990/rainbow {}
   ; :thecontinium/asyncomplete-conjure.vim {}
  }

; :tpope/vim-fireplace {} ; Clojure
; :tpope/vim-sexp-mappings-for-regular-people {}
  )

(use packages)


;;   call minpac#add('dense-analysis/ale') " Linting
;;   call minpac#add('editorconfig/editorconfig-vim')
;;   call minpac#add('elixir-lang/vim-elixir') " Elixir
;;   call minpac#add('ElmCast/elm-vim') " Elm
;;   call minpac#add('jgdavey/tslime.vim', {'branch': 'main'}) " Send to Tmux
;;   call minpac#add('leafgarland/typescript-vim') " TypeScript
;;   call minpac#add('idris-hackers/idris-vim') " Idris
;;   call minpac#add('mxw/vim-jsx') " React JSX support
;;   call minpac#add('neomake/neomake') " Linting/Make
;;   call minpac#add('nvie/vim-flake8') " Python
;;   call minpac#add('pangloss/vim-javascript') " JavaScript
;;   call minpac#add('prabirshrestha/async.vim') " Vim/NeoVim async normalization
;;   call minpac#add('prabirshrestha/asyncomplete.vim') " Language Server Protocol
;;   call minpac#add('raichoo/purescript-vim') " PureScript
;;   call minpac#add('reasonml-editor/vim-reason') " ReasonML
;;   call minpac#add('thoughtbot/vim-rspec')
;;   call minpac#add('vim-erlang/erlang-motions.vim') " Erlang
;;   call minpac#add('vim-erlang/vim-erlang-runtime') " Erlang
;;   call minpac#add('vim-erlang/vim-erlang-compiler') " Erlang
;;   call minpac#add('vim-erlang/vim-erlang-omnicomplete') " Erlang
;;   call minpac#add('vim-erlang/vim-erlang-tags') " Erlang
;;   call minpac#add('vim-erlang/vim-erlang-skeletons') " Erlang
;;   call minpac#add('vim-ruby/vim-ruby') " Ruby
;;   call minpac#add('vim-syntastic/syntastic')
;;   call minpac#add('vim-jp/syntax-vim-ex')
;;   call minpac#add('tsandall/vim-rego') " Rego
;;

;;   " call minpac#add('guns/vim-clojure-static') " Clojure
;;   "" call minpac#add('guns/vim-sexp') " Lisps
;;   " call minpac#add('ncm2/float-preview.nvim') " autocomplete with preview
;;   " call minpac#add('Shougo/deoplete.nvim') " async completion
;;   " call minpac#add('prabirshrestha/vim-lsp') " Language Server Protocol
;;   " call minpac#add('rhysd/vim-lsp-ale') " vim-lsp + ALE
;;   " call minpac#add('mattn/vim-lsp-settings') " Generic LSP Server install and settings for all languages
;;   " call minpac#add('prabirshrestha/asyncomplete-lsp.vim') " Language Server Protocol
;;   " call minpac#add('prabirshrestha/vim-lsp') " Language Server Protocol
;;   " call minpac#add('rhysd/vim-lsp-ale') " vim-lsp + ALE
