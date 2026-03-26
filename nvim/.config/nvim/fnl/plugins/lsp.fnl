(import-macros {: tx} :config.macros)
;
;

(vim.diagnostic.config {:signs {:text {vim.diagnostic.severity.ERROR "☢️"
                                       vim.diagnostic.severity.WARN "⚠️"
                                       vim.diagnostic.severity.INFO "ℹ️"
                                       vim.diagnostic.severity.HINT "🔎"
                                       }
                                ;; :linehl {vim.diagnostic.severity.ERROR :ErrorMsg}
                                ;; :numhl {vim.diagnostic.severity.WARN :WarningMsg}
                                }})

(local client-nmappings {:clojure_lsp {;;:<leader>cn "call LspExecuteCommand('clean-ns')"
                                       ;; :<leader>ref "call LspExecuteCommand('extract-function', input('Function name: '))"
                                       ;; :<leader>id "call LspExecuteCommand('inline-symbol')"
                                       ;; :<leader>il "call LspExecuteCommand('introduce-let', input('Binding name: '))"
                                       ;;:<leader>m2l "call LspExecuteCommand('move-to-let', input('Binding name: '))"
                                       }})

(local client-command-lnmappings
       {:clojure_lsp {:ai [:add-import-to-namespace
                           [(lambda [] (vim.fn.input "Namespace name: "))]]
                      :am [:add-missing-libspec []]
                      :as [:add-require-suggestion
                           [(lambda [] (vim.fn.input "Namespace name: "))
                            (lambda [] (vim.fn.input "Namespace as: "))
                            (lambda [] (vim.fn.input "Namespace name: "))]]
                      :cc [:cycle-coll []]
                      :cn [:clean-ns []]
                      :cp [:cycle-privacy []]
                      :ct [:create-test []]
                      :df [:drag-forward []]
                      :db [:drag-backward []]
                      :df [:drag-forward []]
                      :dk [:destructure-keys []]
                      :ed [:extract-to-def
                           [(lambda [] (vim.fn.input "Definition name: "))]]
                      :ref [:extract-function
                            [(lambda [] (vim.fn.input "Function name: "))]]
                      :el [:expand-let []]
                      :fe [:create-function []]
                      :il [:introduce-let
                           [(lambda [] (vim.fn.input "Binding name: "))]]
                      :is [:inline-symbol []]
                      :ma [:resolve-macro-as []]
                      :mf [:move-form
                           [(lambda [] (vim.fn.input "File name: "))]]
                      :ml [:move-to-let
                           [(lambda [] (vim.fn.input "Binding name: "))]]
                      :pf [:promote-fn
                           [(lambda [] (vim.fn.input "Function name: "))]]
                      :sc [:change-coll
                           [(lambda []
                              (let [coll-types [:map :list :set :vector]
                                    a (require :nfnl.core)
                                    choice (vim.fn.inputlist (a.concat ["Collection Type:"]
                                                                       (a.map-indexed (fn [[k
                                                                                            v]]
                                                                                        (.. (tostring k)
                                                                                            ". "
                                                                                            v))
                                                                                      coll-types)))]
                                (a.get coll-types choice)))]]
                      :sm [:sort-map []]
                      :tf [:thread-first-all []]
                      :tF [:thread-first []]
                      :tl [:thread-last-all []]
                      :tL [:thread-last []]
                      :ua [:unwind-all []]
                      :uw [:unwind-thread []]}})

;
; (local server-specific-opts {})
;
; (local base-server-opts
;        (let [capabilities (cmp_nvim_lsp.default_capabilities (lsp.protocol.make_client_capabilities))]
;          {: on_attach : capabilities :flags {:debounce_text_changes 150}}))

; (vim.api.nvim_create_user_command :LspExecuteCommand lsp-execute-command
;                                   {:nargs "+"})

(local vim _G.vim)

(local lsps [:clojure_lsp
             ; "fennel_ls"
             :lua_ls
             :jsonls
             :yamlls
             :marksman
             :html
             ; :basedpyright
             ; :ts_ls
             :terraformls
             ; "tailwindcss"
             :dockerls
             :docker_compose_language_service
             :bashls
             ; :taplo
             :sqlls])

(local filetype->formatters
       {:lua [:stylua]
        :sh [:shfmt]
        :python [:ruff_organize_imports :ruff_format]
        :rust [:rustfmt]
        :toml [:taplo]
        ; :clojure [:cljfmt]
        :json [:prettierd]
        :javascript [:prettierd]
        :typescript [:prettierd]
        :jsx [:prettierd]
        :html [:prettierd]
        :css [:prettierd]
        :yaml [:prettierd]
        :markdown [:prettierd]
        :fennel [:fnlfmt]
        :sql [:sqlfmt]
        :gleam [:gleam]
        :_ {:lsp_format :prefer}
        :* [:trim_whitespace :trim_newlines]})

(local formatter->package {:ruff_organize_imports :ruff :ruff_format :ruff})

(local disable-formatter-on-save
       ;; These mess with the buffer, so we keep them available for manual invocation but never automatic.
       {:fennel true :sql true})

(local disable-formatter-auto-install
       ;; These need to be installed outside of Mason.
       {:cljfmt true
        :fnlfmt true
        :rustfmt true
        :trim_whitespace true
        :trim_newlines true
        :gleam true})

(vim.lsp.enable [:clojure :fennel-ls :typedclojure])

[(tx :folke/lsp-colors.nvim {})
 (tx :williamboman/mason.nvim {:tag :v1.11.0 :opts {}})
 (tx :stevearc/conform.nvim
     {:dependencies [:rcarriga/nvim-notify]
      :opts {;;:default_format_opts {:lsp_format :fallback}
             :formatters_by_ft filetype->formatters
             :format_on_save (fn [_buf]
                               (when (and vim.g.dotfiles_format_on_save
                                          (or (= nil
                                                 vim.b.dotfiles_format_on_save)
                                              vim.b.dotfiles_format_on_save)
                                          (not (. disable-formatter-on-save
                                                  vim.bo.filetype)))
                                 {:timeout_ms 500 :lsp_format :fallback}))}
      :config (fn [_ opts]
                (let [conform (require :conform)
                      registry (require :mason-registry)
                      formatters-for-mason {}]
                  (set conform.formatters.shfmt {:prepend_args [:-i :2 :-ci]})
                  (vim.schedule (fn []
                                  (each [_ft formatters (pairs filetype->formatters)]
                                    (each [_idx formatter (ipairs formatters)]
                                      (when (not (. disable-formatter-auto-install
                                                    formatter))
                                        (tset formatters-for-mason
                                              (or (. formatter->package
                                                     formatter)
                                                  formatter)
                                              true))))
                                  (each [formatter _true (pairs formatters-for-mason)]
                                    (let [pkg (registry.get_package formatter)]
                                      (when (not (pkg:is_installed))
                                        (vim.notify (.. "Automatically installing "
                                                        formatter " with Mason."))
                                        (pkg:install))))))
                  (set vim.g.dotfiles_format_on_save true)
                  (conform.setup opts)
                  (set vim.o.formatexpr "v:lua.require'conform'.formatexpr()")))
      :keys [(tx :<leader>tbf
                 (fn []
                   (set vim.b.dotfiles_format_on_save
                        (if (= nil vim.b.dotfiles_format_on_save) false
                            (not vim.b.dotfiles_format_on_save)))
                   (vim.notify (.. "Set vim.b.dotfiles_format_on_save to "
                                   (tostring vim.b.dotfiles_format_on_save))))
                 {:desc "Toggle buffer formatting"})
             (tx :<leader>tgf
                 (fn []
                   (set vim.g.dotfiles_format_on_save
                        (not vim.g.dotfiles_format_on_save))
                   (vim.notify (.. "Set vim.g.dotfiles_format_on_save to "
                                   (tostring vim.g.dotfiles_format_on_save))))
                 {:desc "Toggle global formatting"})]})
 (tx :williamboman/mason-lspconfig.nvim
     {:tag :v1.32.0
      :dependencies [:williamboman/mason.nvim]
      :opts {:ensure_installed lsps :automatic_installation true}})
 (tx :neovim/nvim-lspconfig
     {:lazy false
      :dependencies [:williamboman/mason-lspconfig.nvim
                     :hrsh7th/cmp-nvim-lsp
                     :stevearc/conform.nvim
                     :Olical/nfnl]
      :keys [(tx :<leader>ca #(vim.lsp.buf.code_action)
                 {:desc "Invoke code_action, prompting for an action to take at the cursor"})
             (tx :<leader>fa ; vim.lsp.buf.format
                 (fn []
                   ((. (require :conform) :format)))
                 {:desc "LSP format"})
             (tx :<leader>rn vim.lsp.buf.rename {:desc "LSP rename"})
             (tx :gd vim.lsp.buf.definition {:desc "Go to Definition"})
             (tx :gD vim.lsp.buf.declaration {:desc "Go to Declaration"})
             (tx :gi vim.lsp.buf.implementation {:desc "Go to Implementation"})
             (tx :gr vim.lsp.buf.references {:desc "Show References"})
             (tx :K vim.lsp.buf.hover {:desc "LSP Hover"})
             (tx "[g" vim.lsp.diagnostic.goto_prev
                 {:desc "Previous Diagnostic"})
             (tx "]g" vim.lsp.diagnostic.goto_next {:desc "Next Diagnostic"})
             (tx :<c-k> vim.lsp.buf.signature_help {:desc "Signature Help"})
             ;         :<leader>cl "lua vim.lsp.codelens.run()"
             ;         :<leader>ic "lua vim.lsp.buf.incoming_calls()"
             ;         ;; TODO: think of new mapping; conficts with org mode
             ;         ;; :<leader>oc "lua vim.lsp.buf.outgoing_calls()"
             ;         :<leader>sld "lua vim.diagnostic.open_float(nil, {source = 'always'})"
             ;         :<leader>rn "lua vim.lsp.buf.rename()"
             ;         :<leader>fa "lua vim.lsp.buf.format()"}
             ]
      :config (fn []
                (let [caps ((. (require :cmp_nvim_lsp) :default_capabilities))
                      mlsp (require :mason-lspconfig)
                      a (require :nfnl.core)
                      u (require :dotfiles.util)
                      lsp (require :vim.lsp)
                      cmp_nvim_lsp (require :cmp_nvim_lsp)]
                  (vim.lsp.enable :gleam)

                  (fn bufmap [mode from to opts]
                    (u.noremap mode from to (a.merge {:local? true} opts)))

                  (fn nbufmap [from to opts] (bufmap :n from to opts))

                  (fn xbufmap [from to opts] (bufmap :x from to opts))

                  (u.nnoremap :<leader>li :LspInfo)

                  (fn lsp-execute-command [client cmd ...]
                    (let [buf-uri (vim.uri_from_bufnr 0)
                          cursor (vim.api.nvim_win_get_cursor 0)
                          r (- (a.first cursor) 1)
                          c (a.second cursor)
                          opts [buf-uri r c]
                          args (a.concat opts [...])]
                      ;;(client.exec_cmd {:command cmd :arguments args} {:bufnr 0})
                      (client.request_sync :workspace/executeCommand
                                           {:command cmd :arguments args} nil 0)))

                  (fn bind-client-mappings [client]
                    (let [client-name (a.get client :name)
                          mappings (a.get client-nmappings client-name)
                          command-lnmappings (a.get client-command-lnmappings
                                                    client-name)]
                      (when mappings
                        (each [mapping cmd (pairs mappings)]
                          (nbufmap mapping cmd {})))
                      (when command-lnmappings
                        (each [lnmapping command-mapping (pairs command-lnmappings)]
                          (let [lsp-cmd (a.first command-mapping)
                                ;;lsp-cmd (.. client-name "." (a.first command-mapping))
                                ;;opts (a.second command-mapping)
                                mapping (.. :<leader> lnmapping)
                                cmd (lambda []
                                      (let [opts (accumulate [s "" _i opt (ipairs (a.second command-mapping))]
                                                   (.. s
                                                       (if (= :function
                                                              (type opt))
                                                           (opt)
                                                           opt)))]
                                        (lsp-execute-command client lsp-cmd
                                                             opts)))]
                            (nbufmap mapping cmd
                                     {:desc (.. "LSP command `" lsp-cmd "`")}))))))

                  (fn on_attach [client bufnr]
                    ;(each [mapping cmd (pairs core-nmappings)] ;  (nbufmap mapping cmd {})) ; x mode mappings
                    ;(xbufmap :<leader>fa "lua vim.lsp.buf.format()" ;         {:desc "Format buffer"}) ; --   buf_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
                    ; --   buf_set_keymap('n', 'gS', '<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
                    ; --   buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
                    ; --   buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
                    ; --   buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
                    ; --   buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
                    ; --   buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
                    ; --   buf_set_keymap('n', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
                    ; --   buf_set_keymap('x', '<leader>ic', "<cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
                    (vim.api.nvim_set_option_value :omnifunc
                                                   "v:lua.vim.lsp.omnifunc"
                                                   {:buf 0})
                    (bind-client-mappings client)
                    (when client.server_capabilities.documentHighlightProvider
                      (each [hlgroup base-group (pairs {:LspReferenceRead :SpecialKey
                                                        :LspReferenceText :SpecialKey
                                                        :LspReferenceWrite :SpecialKey})]
                        (vim.api.nvim_set_hl 0 hlgroup
                                             (a.merge (vim.api.nvim_get_hl_by_name base-group
                                                                                   true)
                                                      {:italic true
                                                       :foreground "#6c71c4"
                                                       :background :NONE})))
                      (let [group (vim.api.nvim_create_augroup :LspDocumentHighlight
                                                               {:clear true})]
                        (vim.api.nvim_create_autocmd [:CursorHold :CursorHoldI]
                                                     {: group
                                                      :pattern :<buffer>
                                                      :callback (lambda []
                                                                  (vim.lsp.buf.document_highlight))})
                        (vim.api.nvim_create_autocmd [:CursorMoved]
                                                     {: group
                                                      :pattern :<buffer>
                                                      :callback (lambda []
                                                                  (vim.lsp.buf.clear_references))})))
                    (if client.server_capabilities.documentFormattingProvider
                        (vim.api.nvim_create_autocmd [:BufWritePre]
                                                     {:pattern :<buffer>
                                                      :callback (fn []
                                                                  ((. (require :conform)
                                                                      :format)))}))
                    (print "LSP Client Attached."))

                  (mlsp.setup_handlers (tx (fn [server-name]
                                             (vim.lsp.config server-name
                                                             {:capabilities caps
                                                              : on_attach})
                                             (vim.lsp.enable server-name))
                                           {; :tailwindcss
                                            ; (fn []
                                            ;   ;; https://github.com/tailwindlabs/tailwindcss/discussions/7554#discussioncomment-12991596
                                            ;   ;; https://github.com/tailwindlabs/tailwindcss-intellisense/issues/401#issuecomment-2336568169
                                            ;   ;; https://github.com/tailwindlabs/tailwindcss-intellisense/issues/400#issuecomment-2664427180
                                            ;   (vim.lsp.config "tailwindcss"
                                            ;     {:settings
                                            ;      {:tailwindCSS
                                            ;       {:experimental
                                            ;        {:classRegex [["\\[:[^.\\s]*((?:\\.[^.\\s\\]]*)+)[\\s\\]]" "\\.([^.]*)"]
                                            ;                      ["\\:(\\.[^\\s#]+(?:\\.[^\\s#]+)*)" "\\.([^\\.\\s#]+)"]
                                            ;                      ["class\\s+(\\:[^\\s\\}]*)[\\s\\}]" "[\\:.]([^.]*)"]
                                            ;                      ["class\\s+(\"[^\\}\"]*)\"" "[\"\\s]([^\\s\"]*)"]
                                            ;                      ["class\\s+\\[([\\s\\S]*)\\]" "[\"\\:]([^\\s\"]*)[\"]?"]
                                            ;                      ["class\\s+'\\[([\\s\\S]*)\\]" "([^\\s]*)?"]]}
                                            ;        :includeLanguages {:clojure "html"
                                            ;                           :clojurescript "html"}}}})
                                            ;   (vim.lsp.enable "tailwindcss"))
                                            }))))})
 (tx :RubixDev/mason-update-all {:cmd :MasonUpdateAll
                                 :dependencies [:williamboman/mason.nvim
                                                :Olical/nfnl]
                                 :main :mason-update-all
                                 :opts {}})]
