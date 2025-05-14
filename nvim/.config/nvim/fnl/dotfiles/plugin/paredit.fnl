(local a (require :nfnl.core))
(local treesitter (require :dotfiles.plugin.treesitter))
(local ts-parsers (require :nvim-treesitter.parsers))
(local ts-utils (require :nvim-treesitter.ts_utils))
(local languagetree (require :vim.treesitter.languagetree))

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
    (let [cursor-lang (language-at-cursor)]
      (when cursor-lang
        (->> cursor-lang
             (paredit-lang?)
             (bool->int)
             (set vim.g.paredit_mode))
        (vim.fn.PareditInitBuffer)))))

(vim.api.nvim_create_autocmd [:FileType]
                             {:pattern :ruby
                              :callback (lambda []
                                          (vim.fn.PareditInitBalancingAllBracketsBuffer))})

(vim.api.nvim_create_autocmd [:FileType]
                             {:pattern :javascript
                              :callback (lambda []
                                          (vim.fn.PareditInitBalancingAllBracketsBuffer))})

(vim.api.nvim_create_autocmd [:FileType]
                             {:pattern :terraform
                              :callback (lambda []
                                          (vim.fn.PareditInitBalancingAllBracketsBuffer))})
