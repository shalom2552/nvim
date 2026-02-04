return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.enabled = function()
      return vim.g.completion ~= false -- Check global variable
    end
    return opts
  end,

  keys = {
    {
      "<leader>uq",
      function()
        -- Toggle global variable
        if vim.g.completion == false then
          vim.g.completion = true
        else
          vim.g.completion = false
        end

        vim.g.show_popup = vim.g.completion

        if vim.g.completion then
          vim.diagnostic.enable()
          print("Quiet Mode: OFF (Helpers ON)")
        else
          vim.diagnostic.enable(false)
          print("Quiet Mode: ON (Helpers OFF)")
        end
      end,
      desc = "Toggle Quiet Mode (Global)",
    },
  },
}
