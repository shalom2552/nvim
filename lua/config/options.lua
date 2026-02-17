-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.textwidth = 80 -- wrap line text at 80 caracters

-- Define a global flag to control the popup (Default: ON)
vim.g.show_popup = true

-- Disable auto formating
vim.g.autoformat = false

-- keep basic format for .lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  command = "setlocal shiftwidth=2 tabstop=2 expandtab"
})

-- Automatically opens error details ONLY if the flag is true
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    -- Check our flag and ensure diagnostics are enabled globally
    if vim.g.show_popup and vim.diagnostic.is_enabled() then
      vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "cursor",
        border = "rounded",
      })
    end
  end,
})

-- Hides the inline error messages (we use popup insted)
vim.diagnostic.config({ virtual_text = false })
