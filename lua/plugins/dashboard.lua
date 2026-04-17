return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = function(_, opts)
      local logo = [[
██╗  ██╗         ██╗    ██╗  ██╗    ██╗     
██║  ██║         ██║    ██║ ██╔╝    ██║     
███████║         ██║    █████╔╝     ██║     
██╔══██║    ██   ██║    ██╔═██╗     ██║     
██║  ██║    ╚█████╔╝    ██║  ██╗    ███████╗
╚═╝  ╚═╝     ╚════╝     ╚═╝  ╚═╝    ╚══════╝
      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")

      -- Add directory picker to dashboard entries
table.insert(opts.config.center, 4, {
        action = function()
          local home = vim.fn.expand("~")
          Snacks.picker({
            title = "Select Directory",
            cwd = home,
            format = "file",
            finder = function(_, ctx)
              return require("snacks.picker.source.proc").proc(ctx:opts({
                cmd = "fd",
                args = {
                  "--type", "d",
                  "--hidden",
                  "--ignore-case",
                  "--exclude", ".git",
                  "--exclude", "node_modules",
                  "--exclude", ".venv",
                  "--exclude", "venv",
                  "--exclude", "target",
                  "--exclude", "build",
                  "--exclude", "dist",
                  "."  -- search from cwd (home)
                },
                transform = function(item)
                  item.cwd = home
                  item.file = item.text
                  item.dir = true

                  -- Boost score for non-hidden directories so they appear first
                  local is_hidden = item.text:match("^%.") or item.text:match("/%.")
                  item.score = is_hidden and 1 or 100
                end,
              }), ctx)
            end,
            confirm = function(picker, item)
              picker:close()
              if not item or not item.file then return end
              local dir = item.file:match("^/") and item.file or (home .. "/" .. item.file)
              vim.cmd("cd " .. vim.fn.fnameescape(dir))
              vim.cmd("enew")
              Snacks.explorer()
            end,
          })
        end,
        desc = " Select Directory",
        icon = " ",
        key = "d",
        key_format = "  %s",
      })

      -- Footer
      opts.config.footer = function()
        local quotes = {
          "exit vim? never heard of it.",
          "hjkl gang for life.",
          "there is no place like ~",
          "craft code with intention.",
          "simplicity is the ultimate sophistication.",
          "make it work. make it right. make it fast.",
          "first, solve the problem.",
          "clean code is not written by following rules — it is written by care.",
          "programs must be written for people to read.",
          "the best code is no code at all.",
          "leave it better than you found it.",
        }
        math.randomseed(os.time())
        return { quotes[math.random(#quotes)] }
      end

    end,
  },
}
