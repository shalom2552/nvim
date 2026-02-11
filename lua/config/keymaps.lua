-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- jj exits insert mode AND cancels any active LuaSnip session (prevents <Tab> hijack)
vim.keymap.set("i", "jj", function()
  local ok, ls = pcall(require, "luasnip")
  if ok then ls.unlink_current() end
  return "<Esc>"
end, { expr = true, silent = true, desc = "Exit insert + stop snippet" })

