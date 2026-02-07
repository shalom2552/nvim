-- lua/plugins/snacks.nvim
return {
  "folke/snacks.nvim",
  opts = {

    terminal = {
      win = {
        height = 0.7,  -- Terminal hight 80% of screen
      },
    },

    picker = {
      -- Global setting (acts as a default)
      hidden = true,
      sources = {
        -- Specific override for the 'Find Files' command
        files = { hidden = true },
      },
    },
    explorer = {
      hidden = true,
    },
  },
}
