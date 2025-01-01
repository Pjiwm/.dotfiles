return {

    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        vim.opt.termguicolors = true
        require("bufferline").setup {
            options = {
                always_show_bufferline = true,
                show_close_icon = false,
                show_buffer_close_icons = false,
            },
            highlights = {
                background = {
                    fg = "#ffffff",
                    bg = "#282a36",
                },
                buffer_selected = {
                    fg = "#ffffff",
                    bold = true,
                    bg = "#282a36",
                },
                modified = {
                    fg = "#50fa7b",
                    bg = "#282a36",
                },
                modified_selected = {
                    fg = "#50fa7b",
                    bg = "#282a36",
                },
            },
        }

        local keymap = vim.api.nvim_set_keymap
        local opts = { noremap = true, silent = true }
        -- Buffer navigation
        keymap("n", "]b", "<cmd>BufferLineCycleNext<CR>", opts)
        keymap("n", "[b", "<cmd>BufferLineCyclePrev<CR>", opts)
        keymap("n", ">b", "<cmd>BufferLineMoveNext<CR>", opts)
        keymap("n", "<b", "<cmd>BufferLineMovePrev<CR>", opts)
        keymap("n", "<leader>bb", "<cmd>BufferLinePick<CR>", opts)
        keymap("n", "<leader>bc", "<cmd>bd<CR>", opts)
        keymap("n", "<leader>bC", "<cmd>BufferLineCloseAll<CR>", opts)
        keymap("n", "<leader>bd", "<cmd>BufferLinePickClose<CR>", opts)
        keymap("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", opts)
        keymap("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", opts)
        keymap("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", opts)

        -- Buffer sorting
        keymap("n", "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", opts)
        keymap("n", "<leader>bsi", "<cmd>BufferLineSortByDirectory<CR>", opts)
        keymap("n", "<leader>bsm", "<cmd>BufferLineSortByLastModified<CR>", opts)
        keymap("n", "<leader>bsp", "<cmd>BufferLineSortByFullPath<CR>", opts)
        keymap("n", "<leader>bsr", "<cmd>BufferLineSortByRelativePath<CR>", opts)

        -- Buffer splits
        keymap("n", "<leader>b\\", "<cmd>BufferLineHorizontalSplit<CR>", opts)
        keymap("n", "<leader>b|", "<cmd>BufferLineVerticalSplit<CR>", opts)
    end,
}
