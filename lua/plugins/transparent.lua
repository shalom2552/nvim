-- Transparent background plugin
return {
  "xiyaowong/transparent.nvim",
  lazy = false,

  keys = {
    { "<leader>ut", "<cmd>TransparentToggle<CR>", desc = "Toggle Transparency" },
  },

  opts = {
    -- 1. Exclude CursorLine so it keeps its highlight
    exclude_groups = {
      "CursorLine",
      "CursorLineNr", -- keeps the line number highlighted too
    },

    -- 2. Add extra groups you want to force to be transparent
    extra_groups = {
      "NormalFloat",     -- floating windows
      "FloatBorder",     -- floating window borders
      "TelescopeNormal", -- telescope finder background
      "TelescopeBorder", -- telescope finder borders
      "NeoTreeNormal",   -- file explorer background
      "NeoTreeNormalNC", -- file explorer inactive background
    },
  },
}
