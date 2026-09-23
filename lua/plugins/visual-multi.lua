return {
  "mg979/vim-visual-multi",
  -- Crucial: do not lazy-load this plugin.
  lazy = false,
  init = function()
    -- vim.g.VM_default_mappings = 0 -- Uncomment if you want to turn off default maps


    -- VM drops blink's <CR>/<Up>/<Down>/<C-b>/<C-f> on exit and blink v1 won't reapply them.
    -- Clearing the rest makes blink reapply all on next InsertEnter.
    -- TODO: remove once blink.cmp is v2+ (fixed upstream in saghen/blink.cmp#2266).
    -- Check version: :Lazy (blink.cmp line) or `git -C ~/.local/share/nvim/lazy/blink.cmp describe --tags`
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, "i")) do
          if m.desc and m.desc:find("^blink%.cmp") then vim.keymap.del("i", m.lhs, { buffer = 0 }) end
        end
      end,
    })


  end,
}

