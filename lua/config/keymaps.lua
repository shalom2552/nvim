-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- jj exits insert mode AND cancels any active LuaSnip session (prevents <Tab> hijack)
vim.keymap.set("i", "jj", function()
  local ok, ls = pcall(require, "luasnip")
  if ok then ls.unlink_current() end
  return "<Esc>"
end, { expr = true, silent = true, desc = "Exit insert + stop snippet" })

-- fills the quickfix list that <leader>xq and <leader>xQ read
vim.keymap.set("n", "<leader>xd", vim.diagnostic.setqflist, { desc = "Diagnostics to Quickfix" })

-- dap debugger standard F-keys
vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end)
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end)


