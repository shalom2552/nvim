-- Global cache to store executable names per Makefile path
_G.cpp_runner_targets = _G.cpp_runner_targets or {}

return {
  -- 1. Configure the Notifier UI to wrap text
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        style = "fancy",
        wrap = true,
      },
    },
  },

  -- 2. VISUALS: Keep your Which-Key icon config
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function()
      require("which-key").add({
        { "<leader>r", icon = " " },
      })
    end,
  },

  -- 3. LOGIC: C++ Runner with Makefile Support
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>r",
        function()
          if vim.bo.filetype ~= "cpp" then
            vim.notify("Not a C++ file.", vim.log.levels.WARN, { title = "C++ Runner" })
            return
          end

          vim.cmd("silent! write")

          -- File and directory definitions
          local current_dir = vim.fn.expand("%:p:h")
          local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
          local file_path = vim.fn.expand("%:p")
          local file_name = vim.fn.expand("%:t")
          local single_out_file = vim.fn.expand("%:p:r")

          local makefile_dir = nil

          -- Check for Makefile in current or parent directory
          if vim.fn.filereadable(current_dir .. "/Makefile") == 1 then
            makefile_dir = current_dir
          elseif vim.fn.filereadable(parent_dir .. "/Makefile") == 1 then
            makefile_dir = parent_dir
          end

          -- Helper function to launch a terminal, run the executable, and optionally delete it
          local function run_executable(exe_path, display_name)
            -- Prompt the user to decide whether to clean up the compiled executable
            vim.ui.select({ "Yes", "No" }, { prompt = "Delete executable after run?" }, function(choice)
              -- Abort execution if the user cancels the prompt (e.g., presses Esc)
              if not choice then return end

              -- Escape the path to safely handle spaces or special characters in the shell
              local safe_exe = vim.fn.shellescape(exe_path)

              -- Base command: execute file, print newline, and pause for user input before closing
              local cmd = string.format("%s; echo ''; read -p 'Press Enter to close...'", safe_exe)

              -- Append the shell command to forcefully remove the executable if requested
              if choice == "Yes" then
                cmd = cmd .. string.format("; rm -f %s", safe_exe)
              end

              -- Launch the interactive floating terminal using Snacks.nvim
              require("snacks").terminal({ "bash", "-c", cmd }, {
                interactive = true,
                win = {
                  position = "float",
                  border = "rounded",
                  title = "  Output: " .. display_name .. " ",
                  title_pos = "center",
                },
              })
            end)
          end

          -- Branch 1: Makefile logic
          if makefile_dir then
            local makefile_path = makefile_dir .. "/Makefile"

            -- Retrieve cached executable name for this specific Makefile
            local target_name = _G.cpp_runner_targets[makefile_path]

            local function execute_make()
              vim.notify("Running make in " .. makefile_dir .. "...", vim.log.levels.INFO, { title = "C++ Runner" })
              vim.system({ "make", "-C", makefile_dir }, { text = true }, function(obj)
                vim.schedule(function()
                  if obj.code ~= 0 then
                    vim.notify("Make Failed:\n" .. obj.stderr, vim.log.levels.ERROR, { title = "C++ Runner" })
                  else
                    vim.notify("Make Successful!", vim.log.levels.INFO, { title = "C++ Runner" })
                    run_executable(makefile_dir .. "/" .. target_name, target_name)
                  end
                end)
              end)
            end

            -- If not cached, prompt the user once per session
            if not target_name then
              vim.ui.input({ prompt = "Makefile found. Enter output executable name: " }, function(input)
                if input and input ~= "" then
                  _G.cpp_runner_targets[makefile_path] = input
                  target_name = input
                  execute_make()
                else
                  vim.notify("Compilation cancelled. No target specified.", vim.log.levels.WARN, { title = "C++ Runner" })
                end
              end)
            else
              execute_make()
            end

            -- Branch 2: Single file compilation logic
          else
            vim.notify("Compiling " .. file_name .. "...", vim.log.levels.INFO, { title = "C++ Runner" })
            vim.system({ "g++", "-g", file_path, "-o", single_out_file }, { text = true }, function(obj)
              vim.schedule(function()
                if obj.code ~= 0 then
                  vim.notify("Compilation Failed:\n" .. obj.stderr, vim.log.levels.ERROR, { title = "C++ Runner" })
                else
                  vim.notify("Compilation Successful!", vim.log.levels.INFO, { title = "C++ Runner" })
                  run_executable(single_out_file, file_name)
                end
              end)
            end)
          end
        end,
        desc = "Run C++",
        mode = "n",
      },
    },
  },
}
