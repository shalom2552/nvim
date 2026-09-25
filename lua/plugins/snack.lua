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
            -- Centered bordered popup for all pickers using the vscode preset
            layouts = {
                vscode = {
                    layout = {
                        backdrop = false,
                        width = 0.4,
                        min_width = 80,
                        height = 0.4,
                        box = "vertical",
                        border = true,
                        title = "{title} {live} {flags}",
                        title_pos = "center",
                        { win = "input", height = 1, border = "bottom" },
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", border = "top" },
                    },
                },
            },
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
