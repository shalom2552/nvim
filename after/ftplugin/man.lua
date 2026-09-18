-- Manpage configurations
vim.opt_local.statuscolumn = ""
vim.opt_local.textwidth = 0

-- keep the page loaded, because going back cannot re-read a shortened name
local buf = vim.api.nvim_get_current_buf()
vim.schedule(function()
  pcall(vim.api.nvim_set_option_value, "bufhidden", "hide", { buf = buf })
end)

-- Handle cpp ref links follow
local function follow()
  if require("config.cppman").follow() then return end
  -- plain man pages, where :Man reports a bad word instead of throwing
  local err = require("man").open_page(-1, { tab = -1 }, {})
  if err then
    vim.notify("man.lua: " .. err, vim.log.levels.ERROR)
  end
end

vim.keymap.set("n", "<CR>",          follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "K",             follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<C-]>",         follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<2-LeftMouse>", follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<BS>", "<C-t>", { buffer = true, desc = "Back to previous man page" })
