(local a (require :nfnl.core))

(fn fn? [x]
  (= :function (type x)))

(fn noremap [mode from to opts]
  (let [map-opts {:noremap true :silent true}
        to (if (fn? to)
               to
               (.. ":" to :<cr>))
        buff-num (a.get opts :buff-num)]
    (if (or (a.get opts :local?) buff-num)
        (vim.keymap.set mode from to
                        (a.merge map-opts {:buffer (or buff-num 0)}))
        (vim.keymap.set mode from to map-opts))))

(fn nnoremap [from to opts] (noremap :n from to opts))

(fn tnoremap [from to opts] (noremap :t from to opts))

(fn inoremap [from to opts] (noremap :i from to opts))

(fn vnoremap [from to opts] (noremap :v from to opts))

(fn lnnoremap [from to] (nnoremap (.. :<leader> from) to))

(fn ltnoremap [from to opts] (noremap :v (.. :<leader> from) to opts))

(fn lvnoremap [from to opts] (noremap :t (.. :<leader> from) to opts))

{: noremap
 : nnoremap
 : tnoremap
 : inoremap
 : vnoremap
 : lnnoremap
 : ltnoremap
 : lvnoremap}
