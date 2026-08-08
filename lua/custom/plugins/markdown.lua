-- lua/plugins/markdown.lua

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
  },
  {
    src = "https://github.com/echasnovski/mini.nvim",
  },
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  },
  {
    src = "https://github.com/iamcco/markdown-preview.nvim",
  },
})

-- render-markdown.nvim
require("render-markdown").setup({})

-- markdown-preview.nvim
--
-- Equivalent lazy-loading behavior for:
--   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" }
--   ft = { "markdown" }

local mkdp_loaded = false

local function load_markdown_preview()
  if mkdp_loaded then
    return
  end

  mkdp_loaded = true

  vim.cmd("packadd markdown-preview.nvim")

  -- only needed once after install/update
  vim.fn["mkdp#util#install"]()
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  once = true,
  callback = function()
    load_markdown_preview()
  end,
})

vim.api.nvim_create_user_command("MarkdownPreview", function()
  load_markdown_preview()
  vim.cmd("MarkdownPreview")
end, {})

vim.api.nvim_create_user_command("MarkdownPreviewToggle", function()
  load_markdown_preview()
  vim.cmd("MarkdownPreviewToggle")
end, {})

vim.api.nvim_create_user_command("MarkdownPreviewStop", function()
  load_markdown_preview()
  vim.cmd("MarkdownPreviewStop")
end, {})
