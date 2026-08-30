return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_echo_preview_url = 1
		vim.g.mkdp_port = "9090" -- optional but nice
		vim.g.mkdp_browser = "firefox" -- recommended in tmux
	end,
}
