return {
  "saghen/blink.cmp",
  -- 1. Blink checks this variable before showing suggestions
  opts = function(_, opts)
    opts.enabled = function()
      return vim.b.completion ~= false
    end
    return opts
  end,

  keys = {
    {
      "<leader>uq", -- 'q' for Quiet Mode
      function()
        -- 1. Toggle the variable for Blink (Suggestions)
        vim.b.completion = not vim.b.completion

        -- 2. Toggle the variable for your Pop-up (from options.lua)
        vim.g.show_popup = vim.b.completion

        -- 3. Toggle Neovim's built-in diagnostics
        if vim.b.completion then
          vim.diagnostic.enable()
          print("Quiet Mode: OFF (Helpers ON)")
        else
          vim.diagnostic.enable(false)
          print("Quiet Mode: ON (Helpers OFF)")
        end
      end,
      desc = "Toggle Quiet Mode (All Helpers)",
    },
  },
}
