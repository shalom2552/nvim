-- Seamless Ctrl+h/j/k/l navigation between Neovim splits and tmux panes.
return {
    init = function()
        vim.g.tmux_navigator_no_mappings = 1
    end,
    "christoomey/vim-tmux-navigator",
    keys = {
        { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = { "n", "t" }, desc = "Navigate left" },
        { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  mode = { "n", "t" }, desc = "Navigate down" },
        { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    mode = { "n", "t" }, desc = "Navigate up" },
        { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "Navigate right" },
    },
    lazy = false,  -- Ensures it loads immediately
}
