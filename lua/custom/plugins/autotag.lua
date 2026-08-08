-- lua/plugins/autotag.lua

vim.pack.add({
 {src = "https://github.com/windwp/nvim-ts-autotag"}
})

require('nvim-ts-autotag').setup()
