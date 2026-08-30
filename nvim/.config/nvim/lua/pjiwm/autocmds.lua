-- Auto-reload buffers when files change on disk.
-- This is what lets you work "hand in hand" with external tools (git, Claude,
-- formatters, `:!` commands): when something rewrites a file behind Neovim's
-- back, the buffer is refreshed automatically instead of going stale.
--
-- Note: `autoread` alone is NOT enough. Neovim only *checks* the file's mtime
-- on certain triggers, and by default it never polls while you sit in a buffer.
-- The autocmd below runs `:checktime` on the common "I might have context-
-- switched" events so the check actually happens.

vim.opt.autoread = true

local group = vim.api.nvim_create_augroup("pjiwm_autoreload", { clear = true })

vim.api.nvim_create_autocmd(
    { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" },
    {
        group = group,
        desc = "Check for external file changes and reload the buffer",
        callback = function()
            -- Don't run in the command-line window or while typing a command,
            -- where `:checktime` would throw.
            if vim.fn.mode():match("^c") or vim.fn.getcmdwintype() ~= "" then
                return
            end
            -- Only bother for normal, named, on-disk files.
            if vim.bo.buftype ~= "" then
                return
            end
            vim.cmd("silent! checktime")
        end,
    }
)

-- Let you know when a buffer was reloaded from disk, so a surprise change
-- (e.g. Claude editing the file you're looking at) isn't silent. If the buffer
-- had unsaved edits, Neovim shows its usual conflict prompt instead of
-- clobbering your work.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = group,
    desc = "Notify when a file was changed on disk and reloaded",
    callback = function()
        vim.notify("File changed on disk — buffer reloaded", vim.log.levels.WARN, { title = "autoread" })
    end,
})
