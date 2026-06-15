-- [nfnl] fnl/plugins/conjure.fnl
vim.g["conjure#mapping#doc_word"] = "gk"
vim.g["conjure#log#linked_to_client_state"] = true
vim.g["conjure#client#clojure#nrepl#mapping#session_clone"] = "sC"
vim.g["conjure#extract#tree_sitter#enabled"] = true
vim.g["conjure#filetype#fennel"] = "conjure.client.fennel.nfnl"
vim.g["conjure#log#trim#at"] = 1000000
local function _1_()
  local a = require("nfnl.core")
  local group = vim.api.nvim_create_augroup("ConjureSetClientStateOnGitBranchCheckout", {clear = true})
  local function _2_(e)
    if (nil == e) then
      _G.error("Missing argument e on fnl/plugins/conjure.fnl:29", 2)
    else
    end
    local branch = a["get-in"](e, {"data", "branch_name"})
    local feature
    local function _4_()
      local tbl_26_ = {}
      local i_27_ = 0
      for s in string.gmatch(branch, "[^/]*") do
        local val_28_ = s
        if (nil ~= val_28_) then
          i_27_ = (i_27_ + 1)
          tbl_26_[i_27_] = val_28_
        else
        end
      end
      return tbl_26_
    end
    feature = a.first(_4_())
    vim.cmd.ConjureClientState(feature)
    return false
  end
  return vim.api.nvim_create_autocmd({"User"}, {group = group, pattern = "NeogitBranchCheckout", callback = _2_})
end
return {"Olical/conjure", config = _1_, dependencies = {"NeogitOrg/neogit"}, event = "VeryLazy"}
