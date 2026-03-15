return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Change the separators to curves
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "│", right = "│" }
    end,
  },

  -- Enable text wrapping in the Snacks picker preview window.
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          preview = {
            wo = { wrap = true }
          }
        }
      }
    }
  },
}
