-- nvim-treesitter MAIN branch.
--
-- The `master` branch is frozen and is INCOMPATIBLE with Neovim 0.11+: its
-- query directive handlers (e.g. `set-lang-from-info-string!`) assume the old
-- single-node query-match API, but on 0.12 a match capture is an array of
-- nodes. During injection parsing that mismatch throws
--   treesitter.lua: attempt to call method 'range' (a nil value)
-- which is the crash we hit on markdown code fences, Vue templates, etc.
--
-- The main branch drops `configs.setup{ ensure_installed/highlight/indent }`.
-- You install parsers explicitly and start highlighting/indent yourself.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- the main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        ts.setup()

        -- Install the parsers we use. Already-installed ones are skipped, so
        -- this is a no-op on subsequent launches. (`markdown_inline` is what
        -- highlights fenced code blocks — the injection path that crashed.)
        ts.install({
            "bash", "c", "css", "diff", "html", "javascript", "jsdoc",
            "json", "lua", "markdown", "markdown_inline", "python",
            "rust", "scss", "toml", "tsx", "typescript", "vim", "vimdoc",
            "vue", "yaml", "haskell", "hcl", "terraform", "xml",
        })

        local group = vim.api.nvim_create_augroup("pjiwm_treesitter", { clear = true })

        -- Start highlighting + indentation per buffer. On the main branch these
        -- are no longer setup() options — you enable them here.
        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            callback = function(args)
                local buf = args.buf
                local ft = vim.bo[buf].filetype

                -- Keep the old exceptions: skip html, and skip huge files.
                if ft == "html" then
                    return
                end
                local max_filesize = 100 * 1024 -- 100 KB
                local ok_stat, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok_stat and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB, treesitter disabled for performance",
                        vim.log.levels.WARN,
                        { title = "Treesitter" }
                    )
                    return
                end

                -- No installed parser for this filetype -> fall back to vim syntax.
                if not pcall(vim.treesitter.start, buf) then
                    return
                end

                -- Treesitter-based indentation (experimental on main).
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                -- Preserve the old `additional_vim_regex_highlighting` for markdown.
                if ft == "markdown" then
                    vim.bo[buf].syntax = "on"
                end
            end,
        })
    end,
}
