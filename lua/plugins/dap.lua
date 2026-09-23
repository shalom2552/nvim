-- Custom nvim-dap configuration with Telescope executable picker
return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")

    -- Telescope picker for executables
    local telescope_launch = {
      name = "Launch with Telescope",
      type = "codelldb",
      request = "launch",
      cwd = "${workspaceFolder}",
      program = function()
        return coroutine.create(function(coro)
          local executables = vim.fn.systemlist(
            "find . -type f -executable -not -path '*/.*' -printf '%T@ %P\\n' | sort -rn | cut -d' ' -f2-"
          )
          if #executables == 0 then
            vim.notify("No executables found", vim.log.levels.WARN)
            coroutine.resume(coro, dap.ABORT)
            return
          end
          vim.ui.select(executables, { prompt = "Select executable:" }, function(choice)
            coroutine.resume(coro, choice and (vim.fn.getcwd() .. "/" .. choice) or dap.ABORT)
          end)
        end)
      end,
    }

    -- Add the Telescope picker option to executable langs
    for _, lang in ipairs({ "c", "cpp", "rust", "zig" }) do
      dap.configurations[lang] = dap.configurations[lang] or {}
      table.insert(dap.configurations[lang], 1, telescope_launch)
    end
  end,
}
