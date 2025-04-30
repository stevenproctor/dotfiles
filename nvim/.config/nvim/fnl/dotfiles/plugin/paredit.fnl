(module dotfiles.plugin.paredit
        {autoload {nvim aniseed.nvim
                   paredit paredit
                   ts-parsers nvim-treesitter.parsers
                   ts-utils nvim-treesitter.ts_utils
                   languagetree vim.treesitter.languagetree}})

(local a (require :aniseed.core))

(set vim.g.paredit_smartjump 1)

(fn list-member? [xs x]
  (a.some #(= x $1) (a.vals xs)))

(fn bool->int [bool] (if bool 1 0))

(fn int->bool [x] (if (= 0 x) false true))

(fn toggle-global! [x]
  (->> (a.get vim.g x)
       (int->bool)
       (not)
       (bool->int)
       (tset vim.g x)))

(fn language-at-cursor []
  (let [parser (ts-parsers.get_parser)
        current-node (ts-utils.get_node_at_cursor)
        range (if current-node [(current-node:range)])
        lang (if range
                 (languagetree.language_for_range parser range))]
    (if lang
        (lang:lang))))

(fn parser-language []
  (let [parser (ts-parsers.get_parser)]
    (when parser
      (parser:lang))))

(local paredit-langs [:clojure
                      :fennel
                      :hy
                      :janet
                      :julia
                      :lfe
                      :lisp
                      :racket
                      :scheme
                      :shen])

(local paredit-host-langs [:org :markdown :asciidoc])

(fn host-lang-in? [langs] (list-member? langs (parser-language)))

(fn paredit-lang? [lang] (list-member? paredit-langs lang))

(fn TreeSitterLangParedit []
  (when (host-lang-in? paredit-host-langs)
    (when-let [cursor-lang (language-at-cursor)]
              (->> cursor-lang
                   (paredit-lang?)
                   (bool->int)
                   (set nvim.g.paredit_mode))
              (nvim.fn.PareditInitBuffer))))

(nvim.ex.autocmd :FileType :ruby :call
                 "PareditInitBalancingAllBracketsBuffer()")

(nvim.ex.autocmd :FileType :javascript :call
                 "PareditInitBalancingAllBracketsBuffer()")

(nvim.ex.autocmd :FileType :terraform :call
                 "PareditInitBalancingAllBracketsBuffer()")

; (nvim.del_augroup_by_name "BabeliteParedit")
; (nvim.get_autocmds {:group "BabeliteParedit"})

;;(let [group (nvim.create_augroup :BabeliteParedit {:clear true})]
;;  (nvim.create_autocmd [:CursorHold :CursorMoved]
;;                       {: group
;;                        ;:pattern ["*.org" "*.md"]
;;                        :callback TreeSitterLangParedit}))
;;

;; (fn paredit-toggle! [] (toggle-global :paredit_mode)
;;       (nvim.fn.PareditInitBuffer)
;; nvim.g.paredit_mode
;;       )
;; 
;; \
;; (int->bool 0)
;; (fn test [x] (a.get nvim.g x))
;; 
;; (test :pareditmode)
;; (a.get nvim.g :paredit_mode)
;; (comment ;
;;   nvim.g.paredit_mode
;;   ;
;; 
;;   (paredit-toggle!)
;;   )
