(local a (require :aniseed.core))
(local u (require :dotfiles.util))
(local lsp (require :vim.lsp))
(local lspconfig (require :lspconfig))
(local cmp_nvim_lsp (require :cmp_nvim_lsp))

(fn bufmap [mode from to] (u.noremap mode from to {:local? true}))

(fn nbufmap [from to] (bufmap :n from to))

(fn xbufmap [from to] (bufmap :x from to))

(vim.diagnostic.config {:signs {:text {vim.diagnostic.severity.ERROR "☢️"
                                       vim.diagnostic.severity.WARN "⚠️"
                                       vim.diagnostic.severity.INFO "ℹ️"
                                       vim.diagnostic.severity.HINT "🔎"}
                                ;; :linehl {vim.diagnostic.severity.ERROR :ErrorMsg}
                                ;; :numhl {vim.diagnostic.severity.WARN :WarningMsg}
                                }})

(local core-nmappings
       {:gd "lua vim.lsp.buf.definition()"
        :gD "lua vim.lsp.buf.declaration()"
        :gi "lua vim.lsp.buf.implementation()"
        :gr "lua vim.lsp.buf.references()"
        :K "lua vim.lsp.buf.hover()"
        "[g" "lua vim.diagnostic.goto_prev()"
        "]g" "lua vim.diagnostic.goto_next()"
        ;:<c-k> "lua vim.lsp.buf.signature_help()"
        :<leader>ca "lua vim.lsp.buf.code_action()"
        :<leader>cl "lua vim.lsp.codelens.run()"
        :<leader>ic "lua vim.lsp.buf.incoming_calls()"
        ;; TODO: think of new mapping; conficts with org mode
        ;; :<leader>oc "lua vim.lsp.buf.outgoing_calls()"
        :<leader>sld "lua vim.diagnostic.open_float(nil, {source = 'always'})"
        :<leader>rn "lua vim.lsp.buf.rename()"
        :<leader>fa "lua vim.lsp.buf.format()"})

(local client-nmappings
       {:clojure_lsp {:<leader>cn "call LspExecuteCommand('clean-ns')"
                      :<leader>ref "call LspExecuteCommand('extract-function', input('Function name: '))"
                      :<leader>id "call LspExecuteCommand('inline-symbol')"
                      :<leader>il "call LspExecuteCommand('introduce-let', input('Binding name: '))"
                      :<leader>m2l "call LspExecuteCommand('move-to-let', input('Binding name: '))"}})

(local client-command-lnmappings
       {:clojure_lsp {:ai [:add-import-to-namespace
                           ["input('Namespace name: ')"]]
                      :am [:add-missing-libspec []]
                      :as [:add-require-suggestion
                           ["input('Namespace name: ')"
                            "input('Namespace as: ')"
                            "input('Namespace name: ')"]]
                      :cc [:cycle-coll []]
                      :cn [:clean-ns []]
                      :cp [:cycle-privacy []]
                      :ct [:create-test []]
                      :df [:drag-forward []]
                      :db [:drag-backward []]
                      :df [:drag-forward []]
                      :dk [:destructure-keys []]
                      :ed [:extract-to-def ["input('Definition name: ')"]]
                      :ef [:extract-function ["input('Function name: ')"]]
                      :el [:expand-let []]
                      :fe [:create-function []]
                      :il [:introduce-let ["input('Binding name: ')"]]
                      :is [:inline-symbol []]
                      :ma [:resolve-macro-as []]
                      :mf [:move-form ["input('File name: ')"]]
                      :ml [:move-to-let ["input('Binding name: ')"]]
                      :pf [:promote-fn ["input('Function name: ')"]]
                      :sc [:change-collection ["input('Collection type: ')"]]
                      :sm [:sort-map []]
                      :tf [:thread-first-all []]
                      :tF [:thread-first []]
                      :tl [:thread-last-all []]
                      :tL [:thread-last []]
                      :ua [:unwind-all []]
                      :uw [:unwind-thread []]}})

(local server-specific-opts {})

(fn bind-client-mappings [client]
  (let [client-name (a.get client :name)
        mappings (a.get client-nmappings client-name)
        command-lnmappings (a.get client-command-lnmappings client-name)]
    (when mappings
      (each [mapping cmd (pairs mappings)]
        (nbufmap mapping cmd)))
    (when command-lnmappings
      (each [lnmapping command-mapping (pairs command-lnmappings)]
        (let [lsp-cmd (a.first command-mapping)
              opts-str (accumulate [s "" i opt (ipairs (a.second command-mapping))]
                         (.. s ", " opt))
              mapping (.. :<leader> lnmapping)
              cmd (.. "call LspExecuteCommand('" lsp-cmd "'" opts-str ")")]
          (nbufmap mapping cmd))))))

(fn on_attach [client bufnr]
  (each [mapping cmd (pairs core-nmappings)]
    (nbufmap mapping cmd)) ; x mode mappings
  (xbufmap :<leader>fa "lua vim.lsp.buf.format()") ; --   buf_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  ; --   buf_set_keymap('n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
  ; --   buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  ; --   buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  ; --   buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  ; --   buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  ; --   buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  ; --   buf_set_keymap('n', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  ; --   buf_set_keymap('x', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
  (vim.api.nvim_set_option_value :omnifunc "v:lua.vim.lsp.omnifunc" {:buf 0})
  (bind-client-mappings client)
  (if client.server_capabilities.documentFormattingProvider
      (vim.api.nvim_create_autocmd [:BufWritePre]
                                   {:pattern :<buffer>
                                    :callback (lambda [] (vim.lsp.buf.format))}))
  (print "LSP Client Attached."))

(local base-server-opts
       (let [capabilities (cmp_nvim_lsp.default_capabilities (lsp.protocol.make_client_capabilities))]
         {: on_attach : capabilities :flags {:debounce_text_changes 150}}))

(fn default-server-handler [server-name]
  (let [specific-opts (a.get server-specific-opts server-name {})
        server (a.get lspconfig server-name)
        server-opts (a.merge base-server-opts specific-opts)]
    (server.setup server-opts)))

(fn lsp-execute-command [cmd ...]
  (let [buf-uri (vim.uri_from_bufnr 0)
        cursor (vim.api.nvim_win_get_cursor 0)
        r (- (a.first cursor) 1)
        c (a.second cursor)
        opts [buf-uri r c]
        args (a.concat opts [...])]
    (vim.lsp.buf.execute_command {:command cmd :arguments args})))


(fn setup-handlers [language_servers]
  (each [_ server-name (pairs language_servers)]
    (default-server-handler server-name)))

(u.nnoremap :<leader>li :LspInfo)

(vim.api.nvim_create_user_command :LspExecuteCommand lsp-execute-command {})

; (let [mason-lspconfig (require :mason-lspconfig)]
;   (when mason-lspconfig
;     (mason-lspconfig.setup)
;     (mason-lspconfig.setup_handlers [default-server-handler])))

{: on_attach
 : default-server-handler
 : setup-handlers
 }

