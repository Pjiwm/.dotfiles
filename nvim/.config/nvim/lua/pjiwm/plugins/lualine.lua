return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup {
            options = {
                icons_enabled = true,
                theme = "dracula",
                -- component_separators = { left = "", right = "" },
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "NvimTree" },
                    winbar = { "NvimTree" },
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "diagnostics",
                    "diff",
                    {
                        "branch",
                        fmt = function(str)
                            if #str > 30 then
                                return str:sub(1, 27) .. "..."
                            else
                                return str
                            end
                        end,
                    },
                },
                lualine_c = { { "filename", file_status = true, path = 1 } },
                lualine_x = { "filetype", "encoding" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        }
    end,
}
