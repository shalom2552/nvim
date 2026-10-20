local detail = true
if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
    vim.api.nvim_create_autocmd("User", {
        pattern = "OilEnter",
        once = true,
        callback = function() require("oil").open_preview() end,
    })
end

return {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
        default_file_explorer = true,
        columns = {
            { "permissions", highlight = "Comment" },
            { "size", highlight = "Comment" },
            { "mtime", highlight = "Comment" },
        },

        float = { max_width = 0.7, max_height = 0.8 },
        view_options = { show_hidden = true },
        skip_confirm_for_simple_edits = true,
        constrain_cursor = "name",
        keymaps = {
            q = { "actions.close", mode = "n" },
            gd = {
                desc = "Toggle file detail view",
                callback = function()
                    detail = not detail
                    require("oil").set_columns(detail and {
                        { "permissions", highlight = "Comment" },
                        { "size", highlight = "Comment" },
                        { "mtime", highlight = "Comment" },
                    } or {})
                end,
            },

            -- disable tmux nav keys
            ["<C-h>"] = false,
            ["<C-l>"] = false,
        },
    },
    keys = { { "-", "<cmd>Oil --float --preview<cr>", desc = "Open parent dir" } },
}
