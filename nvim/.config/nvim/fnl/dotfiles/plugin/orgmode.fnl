(module dotfiles.plugin.orgmode {autoload {orgmode orgmode}})

(orgmode.setup_ts_grammar)

(orgmode.setup {:org_agenda_files ["~/Dropbox/org/*" "~/my-orgs/**/*"]
                :org_default_notes_file "~/Dropbox/org/refile.org"})

(require :dotfiles.plugin.orgbullets)
