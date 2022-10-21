(module dotfiles.plugin.paredit
        {autoload {nvim aniseed.nvim
                   a aniseed.core
                   nu aniseed.nvim.util
                   paredit paredit
                   ts-parsers nvim-treesitter.parsers
                   ts-utils nvim-treesitter.ts_utils
                   languagetree vim.treesitter.languagetree}})

(defn list-member? [xs x] (a.some #(= x $1) (a.vals xs)))

(defn bool->int [bool] (if bool 1 0))

(defn language-at-cursor [] (let [parser (ts-parsers.get_parser)
                                  current-node (ts-utils.get_node_at_cursor)
                                  range (if current-node [(current-node:range)])
                                  lang (if range
                                           (languagetree.language_for_range parser
                                                                            range))]
                              (if lang
                                  (lang:lang))))

(defn parser-language [] (let [parser (ts-parsers.get_parser)]
                           (when parser
                             (parser:lang))))

(def- paredit-langs [:clojure
                     :fennel
                     :hy
                     :janet
                     :julia
                     :lfe
                     :lisp
                     :racket
                     :scheme
                     :shen])

(def- paredit-host-langs [:org :markdown :asciidoc])

(defn- host-lang-in? [langs] (list-member? langs (parser-language)))

(defn paredit-lang? [lang] (list-member? paredit-langs lang))

(defn TreeSitterLangParedit []
      (when (host-lang-in? paredit-host-langs)
        (when-let [cursor-lang (language-at-cursor)]
                  (->> cursor-lang
                       (paredit-lang?)
                       (bool->int)
                       (set nvim.g.paredit_mode))
                  (nvim.fn.PareditInitBuffer))))

; (nvim.del_augroup_by_name "BabeliteParedit")
; (nvim.get_autocmds {:group "BabeliteParedit"})

; (let [group (nvim.create_augroup "BabeliteParedit" {:clear true})]
;   (nvim.create_autocmd ["CursorHold" "CursorMoved"]
;                        {:group group
;                         ;:pattern ["*.org" "*.md"]
;                         :callback TreeSitterLangParedit}))
; 
