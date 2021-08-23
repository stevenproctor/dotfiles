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
  (let [sign-level (.. "LspDiagnosticsSign" level)]
    (nvim.fn.sign_define sign-level
                     {:texthl sign-level
                      :text sign
                      :numhl sign-level})))

(define-sign :Error "☢️")
(define-sign :Warning  "⚠️")
(define-sign :Hint   "🔎")
(define-sign :Information  "ℹ️")

(def core-nmappings
  {
  :gd "lua vim.lsp.buf.definition()"
  :gD "lua vim.lsp.buf.declaration()"
  :gi "lua vim.lsp.buf.implementation()"
  :gr "lua vim.lsp.buf.references()"
  :K "lua vim.lsp.buf.hover()"
  "[g" "lua vim.lsp.diagnostic.goto_prev()"
  "]g" "lua vim.lsp.diagnostic.goto_prev()"
  :<leader>ca "lua vim.lsp.buf.codeaction()"
  :<leader>sld "lua vim.lsp.diagnostic.show_line_diagnostics()"
  :<leader>rn "lua vim.lsp.buf.rename()"
  :<leader>fa "lua vim.lsp.buf.formattting_sync()"
  })

(def client-nmappings
  {:clojure
   {
    :<leader>cn "lua LspExecuteCommand('clean-ns')"
    :<leader>ref "lua LspExecuteCommand('extract-function', vim.api.nvim_eval(\"input('Function name: ')\")')"
    :<leader>id "lua LspExecuteCommand('inline-symbol')"
    :<leader>il "lua LspExecuteCommand('introduce-let', vim.api.nvim_eval(\"input('Binding name: ')\")')"
    :<leader>m2l "lua LspExecuteCommand('move-to-let', vim.api.nvim_eval(\"input('Binding name: ')\")')"
   }
  })


(defn bind-client-mappings [client]
  (let [mappings (a.get client-nmappings client)]
    (when mappings
      (each [mapping cmd (pairs mappings)]
        (nbufmap mapping cmd)))))

(defn on_attach [client bufnr]
  (each [mapping cmd (pairs core-nmappings)]
    (nbufmap mapping cmd))

  ; x mode mappings
  (xbufmap :<leader>fa "lua vim.lsp.buf.formattting_sync()")

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

  ; client autocmds
;  -- vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf_request_sync(vim.api.nvim_get_current_buf(), 'workspace/executeCommand', {command = 'clean-ns', arguments = {vim.uri_from_bufnr(0), vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[2]}, title = 'Clean Namespace'})]]

  (print "LSP Client Attached."))

(let [lspi (require :lspinstall)]
  (when lspi
    (defn lsp-execute-command [cmd ...]
      (let [buf-uri (vim.uri_from_bufnr 0)
            cursor (vim.api.nvim_win_get_cursor 0)
            r (- (a.first cursor) 1)
            c (a.second cursor)
            args [buf-uri r c]
            ]
        (vim.lsp.buf.execute_command {:command cmd
                                      :arguments (a.merge args ...)})))

    (defn setup-servers []
      (lspi.setup)
      (let [lspconfig (require :lspconfig)
            servers (lspi.installed_servers)]
        (each [_ server (pairs servers)]
          ((. lspconfig server :setup) {:on_attach on_attach :flags {:debounce_text_changes 150} }))))

    (defn on-post-install []
      (setup-servers)
      (nvim.ex.bufdo :e))

    (setup-servers)

    (set lspi.post_install_hook on-post-install)
    (nu.fn-bridge :LspExecuteCommand :dotfiles.plugin.lspconfig :lsp-execute-command {:return false})

    (u.nnoremap :<leader>li "LspInfo")))
