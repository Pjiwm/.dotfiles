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
		-- catgoose is the maintained fork of the (abandoned) norcalli/nvim-colorizer.lua.
		-- The old one calls the removed-in-0.13 `vim.tbl_flatten` and warns on startup.
		"catgoose/nvim-colorizer.lua",
	},

	-- Servers listed here are auto-installed via mason and their config/settings
	-- are applied below. Keep this list as the single source of truth.
	opts = {
		servers = {
			lua_ls = {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			},
			ts_ls = {},
			vue_ls = {},
			jdtls = {},
			terraformls = {},
			tflint = {},
		},
	},

	config = function(_, opts)
		local fidget = require("fidget")
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local cmp_lsp = require("cmp_nvim_lsp")
		-- Neovim 0.12's vim.lsp.config passes root_dir a callback and ignores
		-- any return value: root_dir = function(bufnr, on_dir) ... end. The old
		-- lspconfig style of returning the path left on_dir uncalled, so the
		-- server never attached.
		local function root(markers)
			return function(bufnr, on_dir)
				local dir = vim.fs.root(bufnr, markers)
				if dir then
					on_dir(dir)
				end
			end
		end

		fidget.setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(opts.servers),
			-- mason-lspconfig auto-enables EVERY installed server. You have both
			-- `ts_ls` (configured below) and `vtsls` installed — two TypeScript
			-- servers attaching to the same buffer, causing doubled diagnostics,
			-- hover and go-to-definition. Exclude the duplicate; everything else
			-- installed (rust_analyzer, pyright/ruff, cssls, jsonls, …) still
			-- auto-enables.
			automatic_enable = { exclude = { "vtsls" } },
		})

		local capabilities =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		-- Hand completion capabilities to every server once, globally.
		vim.lsp.config("*", { capabilities = capabilities })

		-- Apply the per-server settings declared in `opts.servers` (e.g. the
		-- lua_ls `vim` global). mason-lspconfig auto-enables installed servers,
		-- but it never forwards these settings — so without this loop the
		-- lua_ls config was silently ignored.
		for name, cfg in pairs(opts.servers) do
			if next(cfg) ~= nil then
				vim.lsp.config(name, cfg)
			end
		end

		local vue_ls_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

		-- tsserver (+ Vue typescript plugin)
		vim.lsp.config("ts_ls", {
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_ls_path,
						languages = { "vue" },
						-- Required by Vue Language Tools 3.x for the plugin to
						-- actually wire up; without it .vue TS support is flaky.
						configNamespace = "typescript",
					},
				},
			},
			-- `json` removed: jsonls handles JSON. ts_ls on JSON was redundant.
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			single_file_support = false,
			root_dir = root({ "package.json", "tsconfig.json", ".git" }),
		})

		-- Vue LSP
		vim.lsp.config("vue_ls", {
			filetypes = { "vue" },
			root_dir = root({ "package.json", "tsconfig.json", ".git" }),
		})

		-- Stock lspconfig jdtls: the mason `jdtls` wrapper already resolves
		-- java, the equinox launcher, config_linux and the -data workspace.
		-- We only inject Lombok as a -javaagent so JDT sees generated members
		-- (@RequiredArgsConstructor-injected fields, @Getter/@Setter, @Slf4j's
		-- log); without it every Lombok member reads as "cannot resolve".
		local lombok_jar = vim.fn.stdpath("data") .. "/mason/packages/jdtls/lombok.jar"
		vim.lsp.config("jdtls", {
			cmd = { "jdtls", "--jvm-arg=-javaagent:" .. lombok_jar },
			filetypes = { "java" },
			root_dir = root({ "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" }),
		})

		vim.lsp.config("terraformls", {
			filetypes = { "terraform", "terraform-vars", "hcl" },
			root_dir = root({ ".terraform", "terragrunt.hcl", ".git" }),
		})

		vim.lsp.config("tflint", {
			filetypes = { "terraform", "hcl" },
			root_dir = root({ ".tflint.hcl", ".git" }),
		})

		-- Enable every server declared in opts.servers.
		for name in pairs(opts.servers) do
			vim.lsp.enable(name)
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf
				local function map(mode, lhs, rhs, desc)
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
					vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
				end, "Prev Error")
				map("n", "]e", function()
					vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
				end, "Next Error")
				map("n", "gl", vim.diagnostic.open_float, "Line Diagnostic")
				map("n", "gy", function()
					local line = vim.fn.line(".") - 1
					local diag = vim.diagnostic.get(0, { lnum = line })
					if #diag > 0 then
						vim.fn.setreg("+", diag[1].message)
						print("Yanked diagnostic to clipboard!")
					else
						print("No diagnostic here")
					end
				end, "Yank Diagnostic")
			end,
		})

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
		vim.diagnostic.config({
			-- Modern sign API (replaces the deprecated per-sign `sign_define`).
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = signs.Error,
					[vim.diagnostic.severity.WARN] = signs.Warn,
					[vim.diagnostic.severity.INFO] = signs.Info,
					[vim.diagnostic.severity.HINT] = signs.Hint,
				},
			},
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
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

		require("colorizer").setup({
			filetypes = { "*" },
			user_default_options = { rgb_fn = true, css = true },
		})

		require("conform").setup({
			formatters_by_ft = {
				javascript = { "eslint_d", "prettier" },
				typescript = { "eslint_d", "prettier" },
				vue = { "eslint_d", "prettier" },
				lua = { "stylua" },
				kotlin = { "ktfmt" },
			},
			formatters = {
				-- Match Osprey's Spotless config: ktfmt().kotlinlangStyle()
				ktfmt = { prepend_args = { "--kotlinlang-style" } },
			},
			-- Auto-format Kotlin on save so it stays in sync with Spotless/CI.
			-- Other filetypes keep using the manual Conform Format keymap.
			format_on_save = function(bufnr)
				if vim.bo[bufnr].filetype == "kotlin" then
					return { timeout_ms = 3000, lsp_format = "fallback" }
				end
			end,
		})
	end,
}
