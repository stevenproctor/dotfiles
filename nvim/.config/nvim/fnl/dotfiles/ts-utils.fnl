(local core (require :aniseed.core))

(fn root [bufnr lang]
  (let [parser (vim.treesitter.get_parser bufnr lang {})
        tree (core.first (: parser :parse))]
    (: tree :root)))

(fn make-query [lang query-string]
  (let [query (vim.treesitter.query.parse lang "(headline (stars) @stars)")]
    (fn [bufnr]
      (let [root-node (root bufnr lang)
            iter-captures (query.iter_captures query root-node bufnr 0 -1)]
        iter-captures))))

{: root : make-query}
