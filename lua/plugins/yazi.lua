return {
    {

        "mikavilpas/yazi.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },

        keys = {
            {
                "<leader>-",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
        },

        opts = {
            open_for_directories = false,
            hooks = {
                -- set yazi border bg color the same as its background color
                yazi_opened = function() vim.api.nvim_set_hl(0, "YaziFloatBorder", { fg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg }) end,
            },
            keymaps = {
                show_help = "<f1>",
            },
        },
    },
    {
        "folke/which-key.nvim",
        opts = { spec = { { "<leader>-",  mode = { "n", "v" }, icon = { icon = "󰇥", color = "yellow" } }, }, }
    },
}

