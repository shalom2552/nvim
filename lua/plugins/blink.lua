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
        -- FIXED LOGIC:
        -- If currently OFF (false), turn ON.
        -- If currently ON (true) or Default (nil), turn OFF.
        if vim.b.completion == false then
          vim.b.completion = true
        else
          vim.b.completion = false
        end

        -- Sync the popup variable
        vim.g.show_popup = vim.b.completion

        -- Toggle Diagnostics based on the new state
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
