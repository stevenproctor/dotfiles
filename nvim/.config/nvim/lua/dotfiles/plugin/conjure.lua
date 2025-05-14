-- [nfnl] fnl/dotfiles/plugin/conjure.fnl
local core = require("nfnl.core")
local conjure_config = require("conjure.config")
vim.g["conjure#mapping#doc_word"] = "gk"
vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = "sC"
vim.g["conjure#extract#tree_sitter#enabled"] = true
conjure_config["assoc-in"]({"filetypes"}, core.concat(conjure_config.filetypes(), {"markdown"}))
return conjure_config["assoc-in"]({"filetype", "markdown"}, "conjure.client.clojure.nrepl")
