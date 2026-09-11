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
            "--background-index-priority=normal",
            "--clang-tidy",
            "--completion-style=detailed",
            "--query-driver=**",
            "--log=error",
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
