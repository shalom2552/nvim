return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.enabled = function()
      return vim.g.completion ~= false
    end
    return opts
  end,

  keys = {
    {
      "<leader>uq",
      function()
        -- 1. Toggle the Global Variable
        -- logic: if currently false (OFF), turn true (ON). Otherwise (nil or true), turn false.
        if vim.g.completion == false then
          vim.g.completion = true
        else
          vim.g.completion = false
        end

        -- 2. Sync the popup flag
        vim.g.show_popup = vim.g.completion

        -- 3. Apply Changes
        if vim.g.completion then
          -- TURNING ON
          vim.diagnostic.enable()
          print("IDE Features: ON")
        else
          -- TURNING OFF
          vim.diagnostic.enable(false)
          
          -- This forces Neo-tree to remove the red circles immediately
          local namespaces = vim.diagnostic.get_namespaces()
          for ns_id, _ in pairs(namespaces) do
            vim.diagnostic.reset(ns_id)
          end
          
          print("IDE Features: OFF")
        end

        -- 4. Refresh Neo-tree to reflect the cleared errors
        if package.loaded["neo-tree"] then
           vim.cmd("Neotree refresh")
        end
      end,
      desc = "Toggle IDE Features",
    },
  },
}

