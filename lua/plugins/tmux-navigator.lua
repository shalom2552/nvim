-- Seamless Ctrl+h/j/k/l navigation between Neovim splits and tmux panes.
return {
  "christoomey/vim-tmux-navigator",
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right" },
  },
  lazy = false,  -- Ensures it loads immediately
}
