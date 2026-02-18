-- Custom nvim-dap configuration with Telescope executable picker
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    -- Ensure cpp configurations table exists
    dap.configurations.cpp = dap.configurations.cpp or {}

    -- Insert custom configuration at the top (index 1)
    table.insert(dap.configurations.cpp, 1, {
      name = "Launch with Telescope",
      type = "codelldb",
      request = "launch",
      cwd = "${workspaceFolder}",

      -- Use a function to dynamically determine the program path
      program = function()
        -- Coroutine prevents blocking the Neovim UI while waiting for user input
        return coroutine.create(function(coro)
          -- Find all executable files in the current directory and subdirectories
          local executables = vim.fn.systemlist("find . -type f -executable")

          -- Trigger dressing.nvim (Telescope UI) to queue and show the selection prompt
          vim.ui.select(executables, { prompt = "Select executable:" }, function(choice)
            if choice then
              -- Remove './' prefix and resume the debugger coroutine with the absolute path
              coroutine.resume(coro, vim.fn.getcwd() .. "/" .. choice:gsub("^%./", ""))
            end
          end)
        end)
      end,
    })
  end
}
