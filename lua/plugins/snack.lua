-- lua/plugins/snacks.nvim
return {
  "folke/snacks.nvim",
  opts = {

    terminal = {
      win = {
        position = "right",
        width = 0.3,  -- Terminal width % of screen
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
