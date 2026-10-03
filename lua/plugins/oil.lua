return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    default_file_explorer = true,
    columns = {}, -- no icons/size/perms
    view_options = { show_hidden = true },
    skip_confirm_for_simple_edits = true,
  },
  keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent dir" } },
}
