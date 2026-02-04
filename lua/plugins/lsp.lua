return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false, -- Keep inline errors OFF (as you requested)
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } }, -- Moved from options.lua
            },
          },
        },
      },
    },
  },
}
