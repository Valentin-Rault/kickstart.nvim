-- lua/plugins/neogit.lua

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/NeogitOrg/neogit" },
})

vim.keymap.set("n", "<leader>gg", function()
  require("neogit").open()
end, {
  desc = "Show Neogit UI",
})
