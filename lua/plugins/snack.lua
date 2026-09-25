
-- Explorer floats inside a root split, which breaks vim-tmux-navigator
-- Navigate from the root split instead: nvim window in that direction if any, else the tmux pane.
local function explorer_nav(dir, tmux_flag)
    return function(picker)
        local target = vim.api.nvim_win_call(picker.layout.root.win, function()
            local nr = vim.fn.winnr(dir)
            return nr ~= vim.fn.winnr() and vim.fn.win_getid(nr) or nil
        end)
        if target then
            vim.api.nvim_set_current_win(target)
        elseif vim.env.TMUX then
            vim.fn.system({ "tmux", "select-pane", tmux_flag })
        end
    end
end

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
            -- (command history, search history, etc.)
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

                -- override navigations to fix tmux navigations on snack explorer
                explorer = {
                    actions = {
                        nav_left = explorer_nav("h", "-L"),
                        nav_right = explorer_nav("l", "-R"),
                    },
                    win = {
                        list = {
                            keys = {
                                ["<c-h>"] = "nav_left",
                                ["<c-l>"] = "nav_right",
                            },
                        },
                    },
                },
            },

        },

        -- Show hidden files in explorer
        explorer = {
            hidden = true,
        },

    },
}
