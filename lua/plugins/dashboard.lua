return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
██╗  ██╗         ██╗    ██╗  ██╗    ██╗     
██║  ██║         ██║    ██║ ██╔╝    ██║     
███████║         ██║    █████╔╝     ██║     
██╔══██║    ██   ██║    ██╔═██╗     ██║     
██║  ██║    ╚█████╔╝    ██║  ██╗    ███████╗
╚═╝  ╚═╝     ╚════╝     ╚═╝  ╚═╝    ╚══════╝
      ]]

      -- This adds some spacing above and below the logo
      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")

      -- footer
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
