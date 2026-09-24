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

local diffview_close = { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } }

require("diffview").setup({
  keymaps = {
    view = { diffview_close },
    file_panel = { diffview_close },
    file_history_panel = { diffview_close },
  },
})
