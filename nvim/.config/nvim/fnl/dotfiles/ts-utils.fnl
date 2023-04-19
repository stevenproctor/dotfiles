(module dotfiles.ts-utils {autoload {nvim aniseed.nvim a aniseed.core}})

(defn root [bufnr lang] (let [parser (vim.treesitter.get_parser bufnr lang {})
                              tree (a.first (: parser :parse))]
                          (: tree :root)))

(defn make-query [lang query-string]
      (let [query (vim.treesitter.query.parse lang "(headline (stars) @stars)")]
        (fn [bufnr]
          (let [root-node (root bufnr lang)
                iter-captures (query.iter_captures query root-node bufnr 0 -1)]
            iter-captures))))
