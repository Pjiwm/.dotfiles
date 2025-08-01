return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require('nvim-tree').setup({
            view = {
                width = vim.o.columns,
                side = 'left',
            },
            open_on_tab = false,
            hijack_netrw = true,
            update_cwd = true,
            actions = {
                open_file = {
                    quit_on_open = true
                },
            },
            git = {
                ignore = true,
            },
            update_focused_file = {
                enable = true,
                update_cwd = true,
                ignore_list = {},
            },
        })

        -- Open and reveal the current file on VimEnter
        vim.cmd([[
            autocmd VimEnter * lua require("nvim-tree.api").tree.open()
            autocmd VimEnter * lua require("nvim-tree.api").tree.find_file({ open = true })
        ]])

        -- Optional keymap to trigger reveal manually like IntelliJ's "target"
        vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>lua require("nvim-tree.api").tree.find_file({open = true})<CR>', { noremap = true, silent = true })

        -- Toggle tree
        vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
}
