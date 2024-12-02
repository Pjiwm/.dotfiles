return {
   "Mofiqul/dracula.nvim" ,
   name = "dracula",
   opts = {
    colorscheme = "dracula",
    transparent_bg = true,
    overrides = function(colors)
         return {
            Normal = { bg = "NONE" }, -- Transparent background
            NormalFloat = { bg = "NONE" }, -- For floating terminals
         }
      end,
   },
}
