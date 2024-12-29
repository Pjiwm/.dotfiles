return {
    "Mofiqul/dracula.nvim",
    name = "dracula",
    opts = {
        colorscheme = "dracula",
        transparent_bg = true,
        overrides = function(colors)
            return {
                Normal = { bg = "NONE" },
                NormalFloat = { bg = "NONE" },
            }
        end,
    },
}
