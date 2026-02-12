-- lua/plugins/colors.lua
-- Adds an interactive color picker and automatic color highlighting
return {
  "uga-rosa/ccc.nvim",
  opts = {
    highlighter = {
      auto_enable = true,
      lsp = true,
    },
  },
  keys = {
    { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color Picker" },
    { "<leader>cv", "<cmd>CccConvert<cr>", desc = "Convert Color Format" },
  },
}
