(local u (require :dotfiles.util))

(local conceals {:defn "𝑓"
                 ;; :defn- :
                 :fn "λ"
                 :lambda "λ"
                 :and "∧"
                 :&& "∧"
                 :or "∨"
                 :|| "∨"
                 :not "¬"
                 :! "¬"
                 :for "∀"
                 :in "∈"
                 ; "\\<not\\> \\<in\\>" :∉
                 :true "⊤"
                 :false "⊥"
                 ;; and
                 ;; or
                 ;; if-not
                 ;; when-not
                 ;; (not
                 ;; None        | ∅
                 ;; true, false | ⊤, ⊥ (top and bottom from logic)
                 ;; 
                 ;; for         | ∀
                 ;; in          | ∈
                 ;; not in      | ∉
                 })

(fn setup-conceals []
  (vim.fn.clearmatches)
  (each [the-match replacement (pairs conceals)]
    (let [the-match (.. "\\<" the-match "\\>")]
      (vim.fn.matchadd :Conceal the-match 0 -1 {:conceal replacement})))
  (set vim.wo.conceallevel 2)
  (set vim.wo.concealcursor :nvc))

(fn toggle-conceal []
  (if (= 0 vim.wo.conceallevel)
      (set vim.wo.conceallevel 2)
      (set vim.wo.conceallevel 0)))

;(setup-conceals)
;(toggle-conceal)
;(if true true false)

(vim.api.nvim_create_user_command :ToggleConceal toggle-conceal {})
(vim.api.nvim_create_user_command :SetupConceals setup-conceals {})
(u.nnoremap :<leader>ts "call ToggleConceal()")

(local pretty-filetypes [:fennel :clojure])

(each [_ ftype (pairs pretty-filetypes)]
  (vim.api.nvim_create_autocmd [:FileType]
                               {:pattern ftype :callback setup-conceals}))

{: setup-conceals}
