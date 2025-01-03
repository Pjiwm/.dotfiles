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
        })

        vim.cmd([[autocmd VimEnter * NvimTreeOpen]])

        vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
}
