return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- Change the separators to curves
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "│", right = "│" }

      -- Clear only section c (the rail between bubbles) — keeps bubbles intact
      local ok, theme = pcall(require, "lualine.themes.auto")
      if ok then
        for _, mode in pairs(theme) do
          if mode.c and type(mode.c) == "table" then
            mode.c.bg = "none"
          end
        end
        opts.options.theme = theme
      end
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
