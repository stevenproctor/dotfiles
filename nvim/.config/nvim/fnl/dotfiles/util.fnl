(module dotfiles.util
  {autoload
   {a aniseed.core}
   require
   {nvim aniseed.nvim}})


(defn noremap [mode from to opts]
  (let [map-opts {:noremap true :silent true}
        to (.. ":" to "<cr>")
        buff-num (a.get opts :buff-num)]

    (if (or (a.get opts :local?) buff-num )
      (nvim.buf_set_keymap (or buff-num 0) mode from to map-opts)
      (nvim.set_keymap mode from to map-opts))))

(defn nnoremap [from to opts]
  (noremap :n from to opts))

(defn lnnoremap [from to]
  (nnoremap (.. "<leader>" from) to))
