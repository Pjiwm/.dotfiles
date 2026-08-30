-- Native Claude Code CLI integration for Neovim.
-- Implements the same WebSocket/MCP protocol as the official VS Code and
-- JetBrains extensions, so Claude auto-detects this editor and can:
--   * receive your visual selections / buffers as context
--   * propose edits as native diffs you accept or reject in-place
--   * see your open files and diagnostics
--
-- Works alongside a tmux-pane workflow; combined with the autoreload autocmds,
-- files Claude edits refresh in your buffers automatically.
return {
	-- snacks provides the terminal split Claude runs in. A bare `opts = {}`
	-- initializes the global `Snacks` object so the terminal module is ready.
	{ "folke/snacks.nvim", opts = {} },

	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		opts = {
			auto_start = true,
			terminal = {
				split_side = "right",
				split_width_percentage = 0.35,
				provider = "auto", -- prefers snacks, falls back to native terminal
				auto_insert = true,
			},
			diff_opts = {
				layout = "vertical",
			},
		},
		cmd = {
			"ClaudeCode",
			"ClaudeCodeFocus",
			"ClaudeCodeSelectModel",
			"ClaudeCodeAdd",
			"ClaudeCodeSend",
			"ClaudeCodeStatus",
			"ClaudeCodeDiffAccept",
			"ClaudeCodeDiffDeny",
		},
		keys = {
			{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude: toggle" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Claude: focus" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: resume session" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: continue session" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Claude: select model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude: send selection" },
			-- Accept / reject the diff Claude is proposing.
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Claude: accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Claude: deny diff" },
		},
	},
}
