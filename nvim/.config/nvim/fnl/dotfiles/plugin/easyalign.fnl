(module dotfiles.plugin.easyalign
  {autoload {nvim aniseed.nvim
             util dotfiles.util }})

(util.noremap :v :<leader><bslash> "EasyAlign*<Bar>")
