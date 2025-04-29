(local treesitter-configs (require :nvim-treesitter.configs))

(treesitter-configs.setup {:highlight {:enable true
                                       ;; :additional_vim_regex_highlighting false
                                       :additional_vim_regex_highlighting [:org]}
                           :ensure_installed :all
                           ; [:org]
                           :rainbow {:enable true
                                     :extended_mode true
                                     ; Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                                     :max_file_lines 10000
                                     ; Do not enable for files with more than 1000 lines, int
                                     :colors ["#dc322f"
                                              ; red
                                              "#b58900"
                                              ; yellow
                                              "#d33682"
                                              ; magenta
                                              "#859900"
                                              ; green
                                              "#2aa198"
                                              ; cyan
                                              "#268bd2"
                                              ; blue
                                              "#6c71c4"
                                              ; violet / brmagenta
                                              ]
                                     ; table of hex strings
                                     }})

; lua print(require('nvim-treesitter.parsers').get_parser():language_for_range({ require('nvim-treesitter.ts_utils').get_node_at_cursor():range() }):lang())
