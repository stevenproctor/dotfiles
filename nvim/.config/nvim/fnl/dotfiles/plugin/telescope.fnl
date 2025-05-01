(local util (require :dotfiles.util))
(local telescope (require :telescope))

(local vimgrep_arguments [:ag
                          :--nocolor
                          :--noheading
                          :--number
                          :--column
                          :--nobreak
                          :--smart-case
                          :--hidden
                          ; "--skip-vcs-ignores"
                          ; "-g" "!.git/"
                          :--ignore
                          :.git
                          :--follow])

(telescope.load_extension :projects)
(telescope.load_extension :yank_history)

(telescope.setup {;; :defaults {: vimgrep_arguments}
                  :pickers {:buffers {:mappings {:n {:d :delete_buffer}}}}
                  :extensions {:projects {:projects {}}}})

(util.lnnoremap :fc "Telescope commands")
(util.lnnoremap :fC "Telescope command_history")
(util.lnnoremap :ff "Telescope git_files hidden=true")
(util.lnnoremap :f- "Telescope find_files")
(util.lnnoremap :fg "Telescope live_grep")
(util.lnnoremap "*" "Telescope grep_string")
(util.lnnoremap :fb "Telescope buffers")
(util.lnnoremap :fd "Telescope diagnostics")
(util.lnnoremap :fH "Telescope help_tags")
(util.lnnoremap :fh "Telescope oldfiles")
(util.lnnoremap :fp "Telescope projects")
(util.lnnoremap :fm "Telescope keymaps")
(util.lnnoremap :fM "Telescope marks")
(util.lnnoremap :ft "Telescope filetypes")
(util.lnnoremap :fq "Telescope quickfix")
(util.lnnoremap :fl "Telescope loclist")
(util.lnnoremap :fsi "Telescope lsp_implementations")
(util.lnnoremap :fsr "Telescope lsp_references")
(util.lnnoremap :fsS "Telescope lsp_document_symbols")
(util.lnnoremap :fss "Telescope lsp_workspace_symbols")
(util.lnnoremap :fy "Telescope yank_history")
