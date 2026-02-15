return {
  -- 1. Configure the Notifier UI to wrap text
  {
    "folke/snacks.nvim",
    opts = {
      notifier = {
        style = "fancy", -- or "compact"
        wrap = true,       -- This enables wrapping in the popups and history
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

  -- 3. LOGIC: Your C++ Runner
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>r",
        function()
          local file = vim.fn.expand("%:p")
          local out_file = vim.fn.expand("%:p:r")
          local file_name = vim.fn.expand("%:t")

          if vim.bo.filetype ~= "cpp" then
            vim.notify("Not a C++ file.", vim.log.levels.WARN, { title = "C++ Runner" })
            return
          end

          vim.cmd("silent! write")

          -- Notify starting
          vim.notify("Compiling " .. file_name .. "...", vim.log.levels.INFO, {
            title = "C++ Runner",
          })

          -- Execute g++ asynchronously
          vim.system({ "g++", "-g", file, "-o", out_file }, { text = true }, function(obj)
            vim.schedule(function()
              if obj.code ~= 0 then
                vim.notify("Compilation Failed:\n" .. obj.stderr, vim.log.levels.ERROR, {
                  title = "C++ Runner",
                })
              else
                -- Compilation Succeeded
                vim.notify("Compilation Successful!", vim.log.levels.INFO, {
                  title = "C++ Runner",
                })

                -- Open floating terminal
                require("snacks").terminal(out_file, {
                  interactive = true,
                  win = {
                    position = "float",
                    border = "rounded",
                    title = "  Output: " .. file_name .. " ",
                    title_pos = "center",
                  },
                })
              end
            end)
          end)
        end,
        desc = "Run C++",
        mode = "n",
      },
    },
  },
}
