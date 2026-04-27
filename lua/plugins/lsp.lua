return {
  {
    "neovim/nvim-lspconfig",
    opts = {

      diagnostics = {
        virtual_text = false, -- Keep inline errors OFF

      },


      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true, -- File watching - auto-detect external file changes
              },
            },
          },
        },

        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--query-driver=/usr/bin/g++,/usr/bin/gcc,**", -- Whitelist g++
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }, -- Make "vim" known by LSP
            },
          },
        },
      },
    },
  },
}
