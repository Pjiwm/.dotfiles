return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "numToStr/Comment.nvim",
        'norcalli/nvim-colorizer.lua',
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require('Comment').setup({
            -- Optional configurations
            mappings = {
                basic = true,     -- Enable basic mappings (gc)
                extra = true,     -- Enable extra mappings (gco, gcO)
                extended = false, -- Disable extended mappings (g>[count][motion])
            },
            vim.keymap.set("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
                { noremap = true, silent = true }),
            vim.keymap.set("v", "<leader>/",
                "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                { noremap = true, silent = true })
        })
        require 'colorizer'.setup({
            '*',
            css = { rgb_fn = true },
        })
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "taplo",
                "hls",
                "pylsp",
                "ts_ls",
                "biome"

            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            local opts = { noremap = true, silent = true, buffer = bufnr }
                            -- Default LSP keymaps
                            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                            vim.keymap.set("n", "go", vim.lsp.buf.type_definition, opts)
                            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                            vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
                            vim.keymap.set("n", "<Leader>lr", vim.lsp.buf.rename, opts)
                            vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
                            vim.keymap.set("n", "<F3>", function() vim.lsp.buf.format({ async = true }) end, opts)
                            vim.keymap.set("n", "<F4>", vim.lsp.buf.code_action, opts)
                            -- Enable format on save if the LSP supports formatting
                            if client.server_capabilities.documentFormattingProvider then
                                vim.api.nvim_buf_create_user_command(bufnr, "Format",
                                    function()
                                        vim.lsp.buf.format({ bufnr = bufnr })
                                    end, { desc = "Format current buffer" })

                                -- Automatically format on save
                                vim.api.nvim_buf_set_option(bufnr, 'formatexpr',
                                    'v:lua.vim.lsp.formatexpr()')
                                vim.cmd(
                                    "autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true })")
                            end
                        end
                    }
                end,
            }
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Down>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require('luasnip').expand_or_jumpable() then
                        require('luasnip').expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require('luasnip').jumpable(-1) then
                        require('luasnip').jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            }),
            completion = {
                autocomplete = false
            }
        })
        local signs = { Error = '', Warn = ' ', Hint = ' ', Info = ' ' }

        for type, icon in pairs(signs) do
            local hl = 'DiagnosticSign' .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
