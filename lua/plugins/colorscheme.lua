return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-mocha",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        opts = {
            transparent_background = true,
            float = { transparent = true },
            custom_highlights = function(c)
                return {
                    LineNr = { fg = c.overlay1 }, -- line numbers
                    BlinkCmpScrollBarThumb = { bg = c.blue }, -- scrollbar color
                }
            end,
        },
    },
}
