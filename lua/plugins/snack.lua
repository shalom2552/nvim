return {
  "folke/snacks.nvim",
  opts = {

    styles = {

      -- Lazygit in a floating window
      lazygit = {
        position = "float",
        width = 0.7,
        border = "rounded",
      },

      -- Floating terminal window
      terminal = {
        position = "float",
        width = 0.7,
        border = "rounded",
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
