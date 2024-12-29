return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        config = function()
            require('telescope').setup({})
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>ff', function()
                local builtin = require('telescope.builtin')
                local is_git_repo = pcall(builtin.git_files)
                if not is_git_repo then
                    builtin.find_files()
                end
            end, { desc = 'Telescope find git files or fallback to find files' })

            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
            vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", fg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", fg = "#6272a4" })
            vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "NONE", fg = "#6272a4" })
            vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "NONE", fg = "#6272a4" })
            vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "NONE", fg = "#6272a4" })
        end
    },
    { "nvim-lua/plenary.nvim" }, -- Add this line
}
