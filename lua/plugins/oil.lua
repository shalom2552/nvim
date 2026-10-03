local detail = false

return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    columns = {}, -- no icons/size/perms
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
    constrain_cursor = "name",
    float = { max_width = 0.7, max_height = 0.8 },
    keymaps = {
      q = { "actions.close", mode = "n" },
      gd = {
        desc = "Toggle file detail view",
        callback = function()
          detail = not detail
          require("oil").set_columns(detail and {
            "icon",
            { "permissions", highlight = "Comment" },
            { "size", highlight = "Comment" },
            { "mtime", highlight = "Comment" },
          } or {})
        end,
      },
    },
  },
  keys = { { "-", "<cmd>Oil --float<cr>", desc = "Open parent dir" } },
}
