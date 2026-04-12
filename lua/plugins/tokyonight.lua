-- lua/plugins/tokyonight.lua
-- Tokyonight theme configuration
return {
  "folke/tokyonight.nvim",
  opts = {
    on_highlights = function(hl, c)
      -- override the split separator to be more visible
      hl.WinSeparator = { fg = c.blue }

      -- Brighter line number colors
      hl.LineNrAbove = { fg = "#65759a", bold = true }
      hl.LineNrBelow = { fg = "#65759a", bold = true }
      hl.CursorLineNr = { fg = "#ffc777", bold = true }

      -- Brighter comments color
      hl.Comment = { fg = "#8a95b0", italic = true }

    end,
  },
}
