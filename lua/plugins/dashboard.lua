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

      -- Inject custom directory picker into dashboard entries
      table.insert(opts.config.center, 4, {
        action = function()
          require("fzf-lua").fzf_exec("fd --type d --hidden --exclude .git", {
            prompt = "Select Directory> ",
            cwd = vim.fn.expand("~"),
            actions = {
              ["default"] = function(selected)
                if selected and #selected > 0 then
                  local target_dir = vim.fn.expand("~") .. "/" .. selected[1]
                  vim.api.nvim_set_current_dir(target_dir)
                  vim.cmd("edit " .. target_dir)
                end
              end
            }
          })
        end,
        desc = " Select Directory",
        icon = " ",
        key = "d",
        key_format = "  %s",
      })

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
