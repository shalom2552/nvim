-- Tokyonight theme configuration
return {
  "folke/tokyonight.nvim",
  opts = {
    on_highlights = function(hl, c)
      -- override the split separator to be more visible
      hl.WinSeparator = {
        fg = c.blue,
      }
    end,
  },
}
