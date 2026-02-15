-- lua/plugins/ide_toggle.lua
return {
  -- Configure nvim-cmp (which replaced blink.cmp)
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    -- Make auto-completion respect our custom global flag
    opts.enabled = function()
      return vim.g.completion ~= false
    end
  end,
  keys = {
    {
      "<leader>uq",
      function()
        -- 1. Toggle the global completion variable
        if vim.g.completion == false then
          vim.g.completion = true
        else
          vim.g.completion = false
        end

        -- 2. Sync the popup flag (used in your options.lua)
        vim.g.show_popup = vim.g.completion

        -- 3. Apply Diagnostic Changes
        if vim.g.completion then
          -- Turn ON inline errors and warnings
          vim.diagnostic.enable()
          print("IDE Features: ON")
        else
          -- Turn OFF inline errors and warnings
          vim.diagnostic.enable(false)

          -- Forcefully clear existing error markers immediately
          local namespaces = vim.diagnostic.get_namespaces()
          for ns_id, _ in pairs(namespaces) do
            vim.diagnostic.reset(ns_id)
          end
          print("IDE Features: OFF")
        end

        -- 4. Refresh Neo-tree to update error indicators next to files
        if package.loaded["neo-tree"] then
           vim.cmd("Neotree refresh")
        end
      end,
      desc = "Toggle IDE Features",
    },
  },
}
