-- lua/plugins/harpoon.lua

vim.pack.add({
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
  },
  {
    src = "https://github.com/ThePrimeagen/harpoon",
    version = "harpoon2",
  },
})

local harpoon = nil

local function get_harpoon()
  if not harpoon then
    harpoon = require("harpoon")
    harpoon:setup()
  end

  return harpoon
end

vim.keymap.set("n", "<leader>ch", function()
  get_harpoon():list():clear()
end, { desc = "[C]lear the [H]arpoon list" })

vim.keymap.set("n", "<leader>a", function()
  get_harpoon():list():add()
end, { desc = "[A]dd file to harpoon list" })

vim.keymap.set("n", "<C-e>", function()
  local h = get_harpoon()
  h.ui:toggle_quick_menu(h:list())
end, { desc = "Toggle harpoon quick menu" })

vim.keymap.set("n", "<C-h>", function()
  get_harpoon():list():select(1)
end)

vim.keymap.set("n", "<C-t>", function()
  get_harpoon():list():select(2)
end)

vim.keymap.set("n", "<C-n>", function()
  get_harpoon():list():select(3)
end)

vim.keymap.set("n", "<C-s>", function()
  get_harpoon():list():select(4)
end)

vim.keymap.set("n", "<C-S-P>", function()
  get_harpoon():list():prev()
end)

vim.keymap.set("n", "<C-S-N>", function()
  get_harpoon():list():next()
end)
