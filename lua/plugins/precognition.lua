-- ~/.config/nvim/lua/plugins/precognition.lua
return {
    "tris203/precognition.nvim",
    event = "VeryLazy",

    opts = {
        startVisible = true,
        showBlankVirtLine = true,
        targetedMotionHints = { enabled = false },
        disabled_fts = { "startify" },
    },

    keys = {
        { "<leader>uP", function() require("precognition").toggle() end, desc = "Toggle Precognition" },
    },

}
