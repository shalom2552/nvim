-- Stop tmux's garbled terminal reply pasting the clipboard into the picker prompt.
--
-- snacks asks the terminal for its version on the first picker preview. tmux
-- turns the reply into keystrokes (tmux/tmux#4386, wontfix), nvim runs them, and
-- the `P` pastes the clipboard. snacks already handles this, but only checks
-- extended-keys `on`, not `always`. Same workaround, any enabled value.
-- Drop this file when snacks widens the check.

local function tmux(...)
  local out = vim.fn.system({ "tmux", ... })
  return vim.v.shell_error == 0 and vim.trim(out) or nil
end

local function patch()
  local extended_keys = vim.env.TMUX and tmux("show", "-g", "extended-keys")
  if not extended_keys or extended_keys:find(" off$") then
    return
  end

  local ok, terminal = pcall(require, "snacks.image.terminal")
  if not ok then
    return
  end

  local env
  for _, e in ipairs(terminal.envs()) do
    if e.name == "tmux" then
      env = e
    end
  end
  if not env then
    return
  end

  env.setup()
  terminal.transform = env.transform

  -- seeding the result makes detect() return before it sends the query
  local name = tmux("display-message", "-p", "#{client_termname}")
  if not name or name == "" then
    name = vim.env.TERM or ""
  end
  terminal._terminal = { terminal = name:gsub("^xterm%-", ""), version = "unknown" }
end

return {
  "folke/snacks.nvim",
  opts = function()
    pcall(patch)
  end,
}
