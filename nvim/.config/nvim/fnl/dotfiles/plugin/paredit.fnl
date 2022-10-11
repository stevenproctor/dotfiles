(module dotfiles.plugin.paredit
  {autoload {nvim aniseed.nvim
             a aniseed.core
             nu aniseed.nvim.util
             paredit paredit
             ts-parsers nvim-treesitter.parsers
             ts-utils nvim-treesitter.ts_utils
             languagetree vim.treesitter.languagetree
             }})

(defn language-at-cursor []
  (let [parser (ts-parsers.get_parser)
        current-node (ts-utils.get_node_at_cursor)
        range (if current-node
                [(current-node:range)]
                [])
        lang (if (not (a.empty? range))
               (languagetree.language_for_range parser range))]
    (if lang (lang:lang))))

(defn parser-language []
  (let [parser (ts-parsers.get_parser)]
    (when parser
      (parser:lang))))

(comment
  (language-at-cursor)
  )

(def paredit-langs
  [
   :clojure
   :fennel
   :hy
   :janet
   :julia
   :lfe
   :lisp
   :racket
   :scheme
   :shen
   ])

(def paredit-host-langs
  [
   :org
   :markdown
   :asciidoc
   ])

(defn paredit-host-lang? [lang]
  (a.some #(= lang $1) (a.vals paredit-host-langs)))

(defn paredit-lang? [lang]
  (a.some #(= lang $1) (a.vals paredit-langs)))

(defn TreeSitterLangParedit []
  (when (paredit-host-lang? (parser-language))
    (let [buff-nr (nvim.buf.nr)
          cursor-lang (language-at-cursor)
          ;buf-paredit-status (a.get-in. {} (nvim.buf.nr))
          paredit-enabled (if (paredit-lang? cursor-lang) 1 0)]
      (set nvim.g.paredit_mode paredit-enabled)
      (nvim.fn.PareditInitBuffer)
      ))
  ; 
  ; ; lua print(require('nvim-treesitter.parsers').get_parser():language_for_range({ require('nvim-treesitter.ts_utils').get_node_at_cursor():range() }):lang())
  )
;(TreeSitterLangParedit)

; (nvim.del_augroup_by_name "BabeliteParedit")
(let [group (nvim.create_augroup "BabeliteParedit" {:clear true})]
  (nvim.create_autocmd ["CursorHold" "CursorMoved"]
                       {:group group
                        ;:pattern ["*.org" "*.md"]
                        :callback TreeSitterLangParedit}))

; (nvim.get_autocmds {:group "BabeliteParedit"})
