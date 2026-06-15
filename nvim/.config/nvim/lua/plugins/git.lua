-- [nfnl] fnl/plugins/git.fnl
return {"NeogitOrg/neogit", cmd = "Neogit", dependencies = {"esmuellert/codediff.nvim", "m00qek/baleia.nvim", "nvim-telescope/telescope.nvim"}, keys = {{"<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI"}}, lazy = true}
