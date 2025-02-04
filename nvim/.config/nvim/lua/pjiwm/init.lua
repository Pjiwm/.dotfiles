require("pjiwm.remap")
require("pjiwm.set")
require("pjiwm.lazy")

vim.cmd [[colorscheme dracula]]

vim.opt.autoread = true
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    command = "checktime",
})
