-- Global cache to store C++ executable names per Makefile path
_G.cpp_runner_targets = _G.cpp_runner_targets or {}

-- Core execution logic extracted so we can pass a "force_single" flag
local function execute_code(force_single)
  -- Save the current buffer before running
  vim.cmd("silent! write")

  -- Common file and directory variables used by all runners
  local filetype = vim.bo.filetype
  local current_dir = vim.fn.expand("%:p:h")
  local file_path = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:t")

  -- =====================================================================
  -- SHARED HELPER: Launch floating terminal
  -- =====================================================================
  local function launch_terminal(cmd, display_name)
    require("snacks").terminal({ "bash", "-c", cmd }, {
      interactive = true,
      win = {
        position = "float",
        border = "rounded",
        title = "  Output: " .. display_name .. " ",
        title_pos = "center",
        width = 0.7, -- Terminal output width
        height = 0.8, -- Terminal output hight
      },
    })
  end

  -- =====================================================================
  -- ROUTER: Execute based on filetype
  -- =====================================================================

  if filetype == "python" then
    ----------------------------------------------------------------------
    -- PYTHON RUNNER
    ----------------------------------------------------------------------
    vim.notify("Running " .. file_name .. "...", vim.log.levels.INFO, { title = "Python Runner" })
    local safe_file = vim.fn.shellescape(file_path)
    local cmd = string.format("python3 %s; echo ''; read -p 'Press Enter to close...'", safe_file)
    launch_terminal(cmd, file_name)

  elseif filetype == "sh" then
    ----------------------------------------------------------------------
    -- BASH RUNNER
    ----------------------------------------------------------------------
    local safe_file = vim.fn.shellescape(file_path)
    local cmd = string.format("bash %s; echo ''; read -p 'Press Enter to close...'", safe_file)
    launch_terminal(cmd, file_name)

  elseif filetype == "cpp" or filetype == "c" then
    ----------------------------------------------------------------------
    -- C/C++ RUNNER
    ----------------------------------------------------------------------
    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
    local single_out_file = vim.fn.expand("%:p:r")
    local makefile_dir = nil

    -- 1. Check for Makefile ONLY if force_single is false
    if not force_single then
      if vim.fn.filereadable(current_dir .. "/Makefile") == 1 then
        makefile_dir = current_dir
      elseif vim.fn.filereadable(parent_dir .. "/Makefile") == 1 then
        makefile_dir = parent_dir
      end
    end

    -- 2. C++ Specific Helper: Prompt for cleanup before running
    local function prompt_and_run(exe_path, display_name, clean_dir)
      vim.ui.select({ "Yes", "No" }, { prompt = "Delete executable & objects after run?" }, function(choice)
        if not choice then return end -- Abort if user presses Esc

        local safe_exe = vim.fn.shellescape(exe_path)
        local cmd = string.format("%s; echo ''; read -p 'Press Enter to close...'", safe_exe)

        -- Append cleanup commands if requested (Bug Fix: safely check if clean_dir exists)
        if choice == "Yes" then
          if clean_dir then
            local safe_dir = vim.fn.shellescape(clean_dir)
            cmd = cmd .. string.format("; make -C %s clean 2>/dev/null; rm -f %s $(dirname %s)/*.o", safe_dir, safe_exe, safe_exe)
          else
            cmd = cmd .. string.format("; rm -f %s $(dirname %s)/*.o", safe_exe, safe_exe)
          end
        end

        launch_terminal(cmd, display_name)
      end)
    end

    -- 3. Execution Branches
    if makefile_dir then
      -- Branch A: Makefile found (and not forced to skip)
      local makefile_path = makefile_dir .. "/Makefile"
      local target_name = _G.cpp_runner_targets[makefile_path]

      local function execute_make()
        vim.notify("Running make in " .. makefile_dir .. "...", vim.log.levels.INFO, { title = "Code Runner" })
        vim.system({ "bash", "-c", "make -C " .. vim.fn.shellescape(makefile_dir) .. " clean && make -C " .. vim.fn.shellescape(makefile_dir) }, { text = true }, function(obj)
          vim.schedule(function()
            if obj.code ~= 0 then
              vim.notify("Make Failed:\n" .. obj.stderr, vim.log.levels.ERROR, { title = "Code Runner" })
            else
              vim.notify("Make Successful!", vim.log.levels.INFO, { title = "Code Runner" })
              prompt_and_run(makefile_dir .. "/" .. target_name, target_name, makefile_dir)
            end
          end)
        end)
      end

      -- Prompt for executable name if not cached
      if not target_name then
        vim.ui.input({ prompt = "Makefile found. Enter output executable name: " }, function(input)
          if input and input ~= "" then
            _G.cpp_runner_targets[makefile_path] = input
            target_name = input
            execute_make()
          else
            vim.notify("Compilation cancelled. No target specified.", vim.log.levels.WARN, { title = "Code Runner" })
          end
        end)
      else
        execute_make()
      end

    else
      -- Branch B: No Makefile OR user explicitly forced single-file mode
      local compiler = (filetype == "cpp") and "g++" or "gcc"

      vim.notify("Compiling single file: " .. file_name .. "...", vim.log.levels.INFO, { title = "Code Runner" })
      vim.system({ compiler, "-g", file_path, "-o", single_out_file }, { text = true }, function(obj)
        vim.schedule(function()
          if obj.code ~= 0 then
            vim.notify("Compilation Failed:\n" .. obj.stderr, vim.log.levels.ERROR, { title = "Code Runner" })
          else
            vim.notify("Compilation Successful!", vim.log.levels.INFO, { title = "Code Runner" })
            prompt_and_run(single_out_file, file_name, nil)
          end
        end)
      end)
    end

  else
    ----------------------------------------------------------------------
    -- FALLBACK RUNNER
    ----------------------------------------------------------------------
    vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.WARN, { title = "Code Runner" })
  end
end

-- =====================================================================
-- PLUGIN REGISTRATION & KEYMAPS
-- =====================================================================
return {
  -- 1. Configure the Notifier UI
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        style = "fancy",
        wrap = true,
      },
    },
  },

  -- 2. VISUALS: Which-Key icon config for both Run commands
  {
    "folke/which-key.nvim",
    optional = true,
    opts = function()
      require("which-key").add({
        { "<leader>r", icon = " " },
        { "<leader>R", icon = " " },
      })
    end,
  },

  -- 3. KEYBINDINGS
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>r",
        function() execute_code(false) end,
        desc = "Run Code (Default)",
        mode = "n",
      },
      {
        "<leader>R",
        function() execute_code(true) end,
        desc = "Run Single File (Ignore Makefile)",
        mode = "n",
      },
    },
  },
}
