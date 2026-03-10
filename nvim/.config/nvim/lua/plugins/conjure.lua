-- [nfnl] fnl/plugins/conjure.fnl
vim.g["conjure#mapping#doc_word"] = "gk"
vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = "sC"
vim.g["conjure#extract#tree_sitter#enabled"] = true
vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.nfnl"
return {"Olical/conjure", event = "VeryLazy"}
