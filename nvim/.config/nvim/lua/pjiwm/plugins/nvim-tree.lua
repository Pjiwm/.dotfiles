return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        require('nvim-tree').setup({
            view = {
                width = 30,
                side = 'left',
            },
            open_on_tab = false,
            auto_close = true,
        })

        vim.cmd([[autocmd VimEnter * NvimTreeOpen]])

        vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
}
