return {
    {
        "nvim-telescope/telescope.nvim",
        -- Track `master`, NOT the 0.1.8 tag. That release (June 2024) is the last
        -- tagged version and its previewer calls nvim-treesitter's old master-branch
        -- API (`nvim-treesitter.parsers.ft_to_lang`, `nvim-treesitter.configs`).
        -- We run nvim-treesitter's `main` rewrite (see treesitter.lua), which deleted
        -- those, so the preview highlighter crashed with
        --   utils.lua: attempt to call field 'ft_to_lang' (a nil value)
        -- Current master rewrote the highlighter to use the builtin
        -- `vim.treesitter.language.*` API, which has no such dependency.
        branch = "master",
        config = function()
            require('telescope').setup({
                defaults = {
                    -- Long paths were unreadable (filename pushed off-screen).
                    -- filename_first shows the name up front, dir dimmed behind it.
                    path_display = { "filename_first" },
                    -- Use more of the screen so long paths aren't truncated.
                    layout_strategy = "horizontal",
                    layout_config = {
                        width = 0.95,
                        height = 0.90,
                        preview_width = 0.45, -- shrink preview → wider results list
                    },
                    -- git_status draws one icon per XY column (staged + worktree),
                    -- so untracked files render the untracked glyph twice. These
                    -- are quieter than the default "?" pair.
                    git_icons = {
                        added = "+",
                        changed = "~",
                        copied = ">",
                        deleted = "-",
                        renamed = "→",
                        unmerged = "‖",
                        untracked = "•",
                    },
                },
            })
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>fF', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>ff', function()
                local builtin = require('telescope.builtin')
                -- --others includes untracked (newly created) files so they're
                -- searchable immediately; --exclude-standard still skips
                -- gitignored files. Use <leader>fF for the unfiltered list.
                local is_git_repo = pcall(builtin.git_files, {
                    git_command = { "git", "ls-files", "--exclude-standard", "--cached", "--others" },
                })
                if not is_git_repo then
                    builtin.find_files()
                end
            end, { desc = 'Telescope git files (incl. untracked) or fallback to find files' })

            -- Changed/new files as a clean path list (no git XY status gutter).
            -- --modified = edited tracked files, --others = untracked/new files,
            -- --exclude-standard = skip gitignored. Rendered like find_files.
            vim.keymap.set('n', '<leader>fc', function()
                builtin.git_files({
                    git_command = { "git", "ls-files", "--exclude-standard", "--modified", "--others" },
                })
            end, { desc = 'Telescope changed/new files (clean list)' })
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
