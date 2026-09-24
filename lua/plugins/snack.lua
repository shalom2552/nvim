return {
    "folke/snacks.nvim",
    opts = {

        styles = {

            -- Add border to floating windows
            float = { border = true },

            -- Lazygit in a floating window
            lazygit = {
                position = "float",
                width = 0.7,
            },

            -- Floating terminal window
            terminal = {
                position = "float",
                width = 0.7,
            },

        },

        picker = {
            -- Show hidden files in picker
            hidden = true,
            sources = {
                files = {
                    -- Show hidden files in 'find files'
                    hidden = true,
                },
            },
        },

        explorer = {
            -- Show hidden files in explorer
            hidden = true,
        },

    },
}
