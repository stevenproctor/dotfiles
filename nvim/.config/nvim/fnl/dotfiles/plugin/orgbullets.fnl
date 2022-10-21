(module dotfiles.plugin.orgbullets
        {autoload {nvim aniseed.nvim a aniseed.core ts-utils dotfiles.ts-utils}})

(def stars ["◉" "⦾" "○" "✸" "✿" "✶" "•" "‣"])

(def stars-query "(headline (stars) @stars)")

(defn star-index [heading-level]
      (let [star-count (a.count stars)
            idx (math.fmod heading-level star-count)]
        (if (< 0 idx)
            idx
            star-count)))

(defonce extmark-namespace (vim.api.nvim_create_namespace :HeaderStars))

(def star-captures (ts-utils.make-query :org stars-query))

(defn gen-star-extmarks []
      (when (= :org vim.bo.filetype)
        (let [bufnr (vim.api.nvim_get_current_buf)
              star-count (a.count stars)]
          (vim.api.nvim_buf_clear_namespace bufnr extmark-namespace 0 -1)
          (each [id node metadata (star-captures bufnr)]
            (let [[start-line start-col end-row end-col] [(node:range)]
                  heading-level (if (= start-line end-row)
                                    (- end-col start-col))
                  star (a.get stars (star-index heading-level))
                  replacement (string.format (a.str "%" (+ 2 heading-level) :s)
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
