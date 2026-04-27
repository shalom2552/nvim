-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua


-- Auto-discover C/C++ files for clangd so cross-file LSP works without compile_commands.json.
-- Runs once per session, skips big projects (>50 files), ignores junk dirs.
local clangd_loaded = false
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if clangd_loaded or not client or client.name ~= "clangd" then return end
    clangd_loaded = true

    local root = client.root_dir or vim.fn.getcwd()
    if vim.fn.filereadable(root .. "/compile_commands.json") == 1 then return end

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
      vim.api.nvim_exec_autocmds("BufRead", { buffer = bufnr })
      vim.lsp.buf_attach_client(bufnr, client.id)
    end
    local ms = (vim.loop.hrtime() - start) / 1e6
    vim.notify(string.format("clangd: auto-loaded %d files (%.0fms)", #files, ms), vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local c = vim.lsp.get_client_by_id(args.data.client_id)
    if c and c.name == "clangd" then clangd_loaded = false end
  end,
})
