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
            custom_highlights = function(c)
                return {
                    BlinkCmpScrollBarThumb = { bg = c.blue }, -- scrollbar color
                }
            end,
        },
    },
}
