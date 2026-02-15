-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- jj exits insert mode AND cancels any active LuaSnip session (prevents <Tab> hijack)
vim.keymap.set("i", "jj", function()
  local ok, ls = pcall(require, "luasnip")
  if ok then ls.unlink_current() end
  return "<Esc>"
end, { expr = true, silent = true, desc = "Exit insert + stop snippet" })

-- dap debugger standard F-keys
local dap = require("dap")
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)

