-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Define a global flag to control the popup (Default: ON)
vim.g.show_popup = true

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

-- Hides the inline error messages (Keep this)
vim.diagnostic.config({ virtual_text = false })
