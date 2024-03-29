(module dotfiles.conceal
  {autoload {nvim aniseed.nvim
             nu aniseed.nvim.util
             u dotfiles.util}})


(def conceals {:defn :𝑓
               ;; :defn- :
               :fn :λ
               :lambda :λ
               :and :∧
               :&& :∧
               :or :∨
               :|| :∨
               :not :¬
               :! :¬
               :for :∀
               :in :∈
               ; "\\<not\\> \\<in\\>" :∉
               :true :⊤
               :false :⊥
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


(defn setup-conceals []
  (nvim.fn.clearmatches)
  (each [the-match replacement (pairs conceals)]
    (let [the-match (.. "\\<" the-match "\\>" )]
      (nvim.fn.matchadd :Conceal the-match 0 -1 {:conceal replacement})))

  (set nvim.wo.conceallevel 2)
  (set nvim.wo.concealcursor :nvc))


(defn toggle-conceal []
  ( if (= 0 nvim.wo.conceallevel)
    (set nvim.wo.conceallevel 2)
    (set nvim.wo.conceallevel 0)))

;(setup-conceals)
;(toggle-conceal)
;(if true true false)


(nu.fn-bridge :ToggleConceal :dotfiles.conceal :toggle-conceal {:return false})
(nu.fn-bridge :SetupConceals :dotfiles.conceal :setup-conceals {:return false})
(u.nnoremap :<leader>ts "call ToggleConceal()")

(def pretty-filetypes [:fennel
                       :clojure])

(each [_ ftype (pairs pretty-filetypes)]
  (nvim.ex.autocmd :FileType ftype :call "SetupConceals()"))

