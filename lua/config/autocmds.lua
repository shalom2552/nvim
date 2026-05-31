-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Manually load all C/C++ files in the project into clangd so cross-file LSP
-- works without compile_commands.json. Trigger with <leader>cL.
local function clangd_load_project()
  local client = vim.lsp.get_clients({ name = "clangd" })[1]
  if not client then
    vim.notify("clangd: not attached", vim.log.levels.WARN)
    return
  end
  local root = client.root_dir or vim.fn.getcwd()
  local files = {}
  for _, ext in ipairs({ "*.c", "*.cpp", "*.cc", "*.h", "*.hpp" }) do
    vim.list_extend(files, vim.fn.globpath(root, "**/" .. ext, false, true))
  end
  files = vim.tbl_filter(function(f)
    return not f:match("[/\\]%.cache[/\\]") and not f:match("[/\\]build[/\\]")
      and not f:match("[/\\]node_modules[/\\]")
  end, files)
  if #files > 100 then
    vim.notify("clangd: too many files, use bear/compiledb", vim.log.levels.WARN)
    return
  end
  local start = vim.loop.hrtime()
  for _, f in ipairs(files) do
    local bufnr = vim.fn.bufadd(f)
    vim.fn.bufload(bufnr)
    vim.bo[bufnr].buflisted = false
    vim.lsp.buf_attach_client(bufnr, client.id)
  end
  local ms = (vim.loop.hrtime() - start) / 1e6
  vim.notify(string.format("clangd: loaded %d files (%.0fms)", #files, ms), vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>cL", clangd_load_project, { desc = "clangd: load project files" })
