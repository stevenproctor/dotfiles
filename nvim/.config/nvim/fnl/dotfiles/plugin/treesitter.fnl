(module dotfiles.plugin.treesitter
  {autoload {treesitter nvim-treesitter.configs}})

(treesitter.setup
  {:highlight {:enable true
               :additional_vim_regex_highlighting false}

   :rainbow {:enable true
             :extended_mode true ; Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
             :max_file_lines 1000 ; Do not enable for files with more than 1000 lines, int
             :colors [
                      :#dc322f ; red
                      :#b58900 ; yellow
                      :#d33682 ; magenta
                      :#859900 ; green
                      :#2aa198 ; cyan
                      :#268bd2 ; blue
                      :#6c71c4 ; violet / brmagenta
                      ] ; table of hex strings
             }
   })
