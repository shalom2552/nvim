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

      -- Green/red diff colors
      hl.DiffAdd    = { bg = "#1a3a2a" }
      hl.DiffDelete = { bg = "#3a1a22" }
      hl.DiffChange = { bg = "#1a2a3a" }
      hl.DiffText   = { bg = "#2a4a3a", bold = true }
    end,
  },
}
