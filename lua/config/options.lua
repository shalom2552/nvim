-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.textwidth = 80 -- wrap line text at 80 caracters

-- LazyVim uses system clipboard by default (unnamedplus), but it breakes on ssh since
-- LazyVim disables clipboard when SSH_CONNECTION is set, which tmux leaks into local windows,
-- so we override it to use unnamedplus on tmux even on SSH_TTY.
-- discussion: https://github.com/LazyVim/LazyVim/discussions/4602
if vim.env.TMUX then vim.opt.clipboard = "unnamedplus" end

-- Disable auto formating
vim.g.autoformat = false

-- Automatically opens error details when diagnostics are enabled
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if vim.diagnostic.is_enabled() then
      vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "cursor",
        border = "rounded",
      })
    end
  end,
})

-- Enable termdebug if gdb is installed
if vim.fn.executable("gdb") == 1 then
  vim.cmd("packadd! termdebug")
end

-- Hides the inline error messages (we use popup insted)
vim.diagnostic.config({ virtual_text = false })

