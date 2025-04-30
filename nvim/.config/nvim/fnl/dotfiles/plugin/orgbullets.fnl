(module dotfiles.plugin.orgbullets {autoload {nvim aniseed.nvim}})

(local core (require :aniseed.core))
(local ts-utils (require :dotfiles.ts-utils))
(local stars ["◉" "⦾" "○" "✸" "✿" "✶" "•" "‣"])

(local stars-query "(headline (stars) @stars)")

(fn star-index [heading-level]
  (let [star-count (core.count stars)
        idx (math.fmod heading-level star-count)]
    (if (< 0 idx)
        idx
        star-count)))

(local extmark-namespace (vim.api.nvim_create_namespace :HeaderStars))

(local star-captures (ts-utils.make-query :org stars-query))

(fn gen-star-extmarks []
  (when (= :org vim.bo.filetype)
    (let [bufnr (vim.api.nvim_get_current_buf)
          star-count (core.count stars)]
      (vim.api.nvim_buf_clear_namespace bufnr extmark-namespace 0 -1)
      (each [id node metadata (star-captures bufnr)]
        (let [[start-line start-col end-row end-col] [(node:range)]
              heading-level (if (= start-line end-row)
                                (- end-col start-col))
              star (core.get stars (star-index heading-level))
              replacement (string.format (core.str "%" (+ 2 heading-level) :s)
                                         star)]
          (vim.api.nvim_buf_set_extmark bufnr extmark-namespace start-line
                                        start-col
                                        {:end_col end-col
                                         :end_row end-row
                                         :virt_text [[replacement []]]
                                         :virt_text_pos :overlay
                                         :hl_mode :combine}))))))

(let [group (nvim.create_augroup :HeaderStars {:clear true})]
  (nvim.create_autocmd [:FileChangedShellPost
                        :Syntax
                        :TextChanged
                        :InsertLeave
                        :WinScrolled]
                       {: group
                        ;; :pattern [:*.org]
                        :callback gen-star-extmarks}))
