(module dotfiles.plugin.lspconfig
  {autoload
   {a aniseed.core
    u dotfiles.util
    nvim aniseed.nvim
    nu aniseed.nvim.util
    }
   })

(defn bufmap [mode from to]
  (u.noremap mode from to {:local? true}))

(defn nbufmap [from to]
  (bufmap :n from to))

(defn xbufmap [from to]
  (bufmap :x from to))


(defn define-sign [level sign]
  (let [sign-level (.. "DiagnosticSign" level)]
    (nvim.fn.sign_define sign-level
                     {:texthl sign-level
                      :text sign
                      :numhl sign-level})))

; (define-sign :Error "☢️")
; (define-sign :Warn  "⚠️")
; (define-sign :SignHint "🔎")
; (define-sign :Info  "ℹ️")
(define-sign :Error "X")
(define-sign :Warn  "!")
(define-sign :SignHint "?")
(define-sign :Info  "i")

(def core-nmappings
  {
  :gd "lua vim.lsp.buf.definition()"
  :gD "lua vim.lsp.buf.declaration()"
  :gi "lua vim.lsp.buf.implementation()"
  :gr "lua vim.lsp.buf.references()"
  :K "lua vim.lsp.buf.hover()"
  "[g" "lua vim.diagnostic.goto_prev()"
  "]g" "lua vim.diagnostic.goto_next()"
  :<c-k> "lua vim.lsp.buf.signature_help()"
  :<leader>ca "lua vim.lsp.buf.code_action()"
  :<leader>cl "lua vim.lsp.codelens.run()"
  :<leader>ic "lua vim.lsp.buf.incoming_calls()"
  :<leader>oc "lua vim.lsp.buf.outgoing_calls()"
  :<leader>sld "lua vim.diagnostic.open_float(nil, {source = 'always'})"
  :<leader>rn "lua vim.lsp.buf.rename()"
  :<leader>fa "lua vim.lsp.buf.formatting_sync()"
  })

(def client-nmappings
  {:clojure_lsp
   {
    :<leader>cn "call LspExecuteCommand('clean-ns')"
    :<leader>ref "call LspExecuteCommand('extract-function', input('Function name: '))"
    :<leader>id "call LspExecuteCommand('inline-symbol')"
    :<leader>il "call LspExecuteCommand('introduce-let', input('Binding name: '))"
    :<leader>m2l "call LspExecuteCommand('move-to-let', input('Binding name: '))"
   }
  })


(defn bind-client-mappings [client]
  (let [client-name (a.get client :name)
        mappings (a.get client-nmappings client-name)]
    (when mappings
      (each [mapping cmd (pairs mappings)]
        (nbufmap mapping cmd)))))

(defn on_attach [client bufnr]
  (each [mapping cmd (pairs core-nmappings)]
    (nbufmap mapping cmd))

  ; x mode mappings
  (xbufmap :<leader>fa "lua vim.lsp.buf.formatting_sync()")

; --   buf_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
; --   buf_set_keymap('n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
; --   buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
; --   buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
; --   buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
; --   buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
; --   buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
; --   buf_set_keymap('n', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
; --   buf_set_keymap('x', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)

  (nvim.buf_set_option 0 :omnifunc "v:lua.vim.lsp.omnifunc")

  (bind-client-mappings client)
  (nvim.ex.autocmd :BufWritePre :<buffer> :lua "vim.lsp.buf.formatting_sync()")
;  (nvim.ex.autocmd "BufEnter,CursorHold,InsertLeave" :<buffer> :lua "vim.lsp.codelens.refresh()")

  ; client autocmds
;  -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), 'workspace/executeCommand', {command = 'clean-ns', arguments = {vim.uri_from_bufnr(1), vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[2]}, title = 'Clean Namespace'})]]

  (print "LSP Client Attached."))

(let [lspi (require :nvim-lsp-installer)]
  (when lspi

    (defn lsp-execute-command [cmd ...]
      (let [buf-uri (vim.uri_from_bufnr 0)
            cursor (vim.api.nvim_win_get_cursor 0)
            r (- (a.first cursor) 1)
            c (a.second cursor)
            opts [buf-uri r c]
            args (a.concat opts [...])]
        (vim.lsp.buf.execute_command {:command cmd
                                      :arguments args})))

    (defn setup-servers []
      (lspi.on_server_ready (fn [server]
                              (let [opts {:on_attach on_attach :flags {:debounce_text_changes 150} }]
                                (server:setup opts))))
      ;; (let [lspconfig (require :lspconfig)
      ;;       servers (lspi.get_installed_servers)]
      ;;   (each [_ server (pairs servers)]
      ;;     (server.setup {:on_attach on_attach :flags {:debounce_text_changes 150} })))
      )

    (defn on-post-install []
      (setup-servers)
      (nvim.ex.bufdo :e))

    (setup-servers)

    (set lspi.post_install_hook on-post-install)
    (nu.fn-bridge :LspExecuteCommand :dotfiles.plugin.lspconfig :lsp-execute-command {:return false})

    (u.nnoremap :<leader>li "LspInfo")))


;; (let [eval (require :conjure.eval)
;;       client (require :conjure.client)
;;       ts-utils (require :nvim-treesitter.ts_utils)
;;       parsers (require :nvim-treesitter.parsers)
;;       ]
;; 
;;     ; client["with-filetype"]("fennel", eval["eval-str"], {
;;     ;   origin = "my-awesome-plugin",
;;     ;   code = "(+ 10 20)",
;;     ;   ["passive?"] = true,
;;     ;   ["on-result"] = function (r)
;;     ;     print("RESULT:", r)
;;     ;   end
;;     ; })
;; 
;;     (defn ts-node-descendent-of? [node ancestor-type]
;;       (print node)
;;       (if (= nil node)
;;         false
;;         (let [node-type (node:type)]
;;           (print node-type)
;;           (if (= ancestor-type node-type)
;;             true
;;             (ts-node-descendent-of? (node:parent) ancestor-type)))))
;; 
;;     (defn in-fenced-code-block? []
;;       (let [cursor (vim.api.nvim_win_get_cursor 0)
;;             lnum (a.first cursor)
;;             col (a.second cursor)
;;             root_lang_tree (parsers.get_parser)
;;             range [ lnum - 1 col lnum - 1 col ]
;;             (node root lang-tree) (ts-utils.get_root_for_position (- lnum 1) col root_lang_tree) ]
;;         (a.pr "language" (a.get lang-tree :_lang :err))
;;         )
;;       (let [node-at-cursor (ts-utils.get_node_at_cursor)]
;;         (print "node at cursor" node-at-cursor)
;;         (a.pr "root for node at cursor " (ts-utils.get_root_for_node node-at-cursor))
;;         (print (ts-node-descendent-of? node-at-cursor :fenced_code_block))))
;; 
;;     (defn markdown-code-to-repl []
;;       ; (let [buf-uri (vim.uri_from_bufnr 0)
;;       ;       cursor (vim.api.nvim_win_get_cursor 0)
;;       ;       r (- (a.first cursor) 1)
;;       ;       c (a.second cursor)
;;       ;       opts [buf-uri r c]
;;       ;       args (a.concat opts [...])]
;;       ;   (vim.lsp.buf.execute_command {:command cmd
;;       ;                                 :arguments args}))
;;       )
;; 
;;     (nu.fn-bridge :MarkdownCodeToRepl :dotfiles.plugin.lspconfig :markdown-code-to-repl {:return false})
;; 
;;     (nu.fn-bridge :IsInFencedCodeBlock :dotfiles.plugin.lspconfig :in-fenced-code-block? {:return false})
;; 
;;     ;; If file type is Markdown
;;     ;(u.nnoremap :<leader>ee "call MarkdownCodeToRepl")
;;     
;;   )
;; 
