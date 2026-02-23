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

-- remap notification history to <leader>N
vim.keymap.set("n", "<leader>N", function()
  if Snacks.config.picker and Snacks.config.picker.enabled then
    Snacks.picker.notifications()
  else
    Snacks.notifier.show_history()
  end
end, { desc = "Notification History" })

-- Floating window for scratch note
vim.keymap.set("n", "<leader>n", function()
  local path = vim.fn.expand("~/.local/share/nvim/scratch.txt")
  local buf = vim.fn.bufnr(path)
  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, path)
  end
  -- hide from bufferline tabs
  vim.api.nvim_set_option_value("buflisted", false, { buf = buf })

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.6),
    height = math.floor(vim.o.lines * 0.6),
    col = math.floor(vim.o.columns * 0.2),
    row = math.floor(vim.o.lines * 0.2),
    border = "rounded",
    title = " scratch ",
    title_pos = "center",
  })
  vim.cmd("edit " .. path)
  vim.api.nvim_set_option_value("buflisted", false, { buf = buf })

  local function close()
    vim.cmd("silent! write")
    vim.api.nvim_win_close(win, true)
  end

  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf })
end, { desc = "Scratch note (float)" })

