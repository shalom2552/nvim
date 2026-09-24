-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Termdebug: run program in gdb's terminal to avoid "Failed to set controlling terminal" warning
vim.api.nvim_create_autocmd("User", {
  pattern = "TermdebugStartPost",
  callback = function()
    vim.fn.TermDebugSendCommand("set inferior-tty")
  end,
})

require("custom.lsp_workspace") -- <leader>cL: load workspace files into lsp for diagnostics
require("custom.noice_paths")   -- noice windows: highlight file:line paths, <CR> to open
