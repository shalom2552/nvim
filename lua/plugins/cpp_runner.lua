return {
  -- Attach to snacks.nvim for terminal and notifications
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>r",
      function()
        -- 1. Get file details
        local file = vim.fn.expand("%:p")        -- Full path to the .cpp file (e.g., /path/main.cpp)
        local out_file = vim.fn.expand("%:p:r")  -- Full path minus extension (e.g., /path/main)
        local file_name = vim.fn.expand("%:t")   -- Just the file name (e.g., main.cpp)

        -- 2. Validate filetype to ensure we only run this in C++ buffers
        if vim.bo.filetype ~= "cpp" then
          vim.notify("Not a C++ file.", vim.log.levels.WARN, { title = "C++ Runner" })
          return
        end

        -- 3. Auto-save the current buffer before compiling
        vim.cmd("silent! write")

        -- 4. Notify that compilation has started
        -- The 'id' ensures this notification gets replaced rather than duplicated
        vim.notify("Compiling " .. file_name .. "...", vim.log.levels.INFO, { title = "C++ Runner", id = "cpp_runner" })

        -- 5. Run g++ asynchronously so Neovim doesn't freeze
        vim.system({ "g++", "-g", file, "-o", out_file }, { text = true }, function(obj)
          -- vim.schedule ensures UI updates happen safely back on the main thread
          vim.schedule(function()
            if obj.code ~= 0 then
              -- Compilation Failed: Show the error message
              vim.notify("Compilation Failed:\n" .. obj.stderr, vim.log.levels.ERROR, { title = "C++ Runner", id = "cpp_runner" })
            else
              -- Compilation Succeeded
              vim.notify("Compilation Successful!", vim.log.levels.INFO, { title = "C++ Runner", id = "cpp_runner" })

              -- 6. Open floating terminal using require("snacks") to prevent nil errors
              require("snacks").terminal(out_file, {
                interactive = true,
                win = {
                  position = "float",
                  border = "rounded",
                  title = " Output: " .. file_name .. " ",
                  title_pos = "center",
                },
              })
            end
          end)
        end)
      end,
      desc = " Run C++",
      mode = "n",
    },
  },
}
