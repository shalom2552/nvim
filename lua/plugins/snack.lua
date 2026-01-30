-- lua/plugins/snacks.nvim
return {
  "folke/snacks.nvim",
  opts = {
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
