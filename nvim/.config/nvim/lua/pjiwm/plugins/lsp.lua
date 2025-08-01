return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"j-hui/fidget.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"stevearc/conform.nvim",
		"numToStr/Comment.nvim",
		"norcalli/nvim-colorizer.lua",
	},

	opts = {
		servers = {
			-- rust_analyzer = {
			--   settings = {
			--     ["rust-analyzer"] = {
			--       cargo = { allFeatures = true },
			--       procMacro = { enable = true },
			--     },
			--   },
			-- },
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			},
			ts_ls = {},
			-- vue_ls = {
			-- 	init_options = {
			-- 		typescript = {
			-- 			tsdk = vim.fn.stdpath("data")
			-- 				.. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
			-- 		},
			-- 	},
			-- },
		},
	},

	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local fidget = require("fidget")
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local cmp_lsp = require("cmp_nvim_lsp")

		fidget.setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(opts.servers) })

		local capabilities =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		lspconfig.vue_ls.setup({
			capabilities = capabilities,
			init_options = {
				typescript = {
					tsdk = vim.fn.stdpath("data")
						.. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
				},
			},
			filetypes = { "vue" },
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf

				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, noremap = true, silent = true })
				end

				map("n", "<leader>lr", vim.lsp.buf.rename, "LSP Rename")
				map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
				map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
				map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
				map("n", "go", vim.lsp.buf.type_definition, "Go to Type Definition")
				map("n", "gr", vim.lsp.buf.references, "Go to References")
				map("n", "gs", vim.lsp.buf.signature_help, "Signature Help")
				map("n", "<F3>", function()
					require("conform").format({ async = true, lsp_fallback = true })
				end, "Conform Format")
				map("n", "<F4>", vim.lsp.buf.code_action, "LSP Code Action")
				map("n", "[e", function()
					vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
				end, "Previous Error")
				map("n", "]e", function()
					vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
				end, "Next Error")
				map("n", "gl", vim.diagnostic.open_float, "Show Line Diagnostic")
				map("n", "gy", function()
					local line = vim.fn.line(".") - 1
					local diag = vim.diagnostic.get(0, { lnum = line })
					if #diag > 0 then
						vim.fn.setreg("+", diag[1].message)
						print("Yanked diagnostic to clipboard!")
					else
						print("No diagnostics found at this location")
					end
				end, "Yank Diagnostic")
			end,
		})

		-- Setup all LSPs
		for server, server_opts in pairs(opts.servers) do
			server_opts.capabilities = capabilities
			lspconfig[server].setup(server_opts)
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
			completion = { autocomplete = false },
		})

		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		vim.diagnostic.config({
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		require("Comment").setup()
		vim.keymap.set(
			"n",
			"<leader>/",
			"<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
			{ noremap = true, silent = true }
		)
		vim.keymap.set(
			"v",
			"<leader>/",
			"<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			{ noremap = true, silent = true }
		)

		require("colorizer").setup({ "*", css = { rgb_fn = true } })

		require("conform").setup({
			formatters_by_ft = {
				javascript = { "eslint_d", "prettier" },
				typescript = { "eslint_d", "prettier" },
				vue = { "eslint_d", "prettier" },
				lua = { "stylua" },
			},
		})
	end,
}
