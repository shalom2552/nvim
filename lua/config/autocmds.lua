-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- skipped when walking a non-git tree
local WALK_SKIP = {
    [".git"] = true,
    [".cache"] = true,
    [".venv"] = true,
    ["build"] = true,
    ["dist"] = true,
    ["node_modules"] = true,
    ["target"] = true,
    ["venv"] = true,
}

local opened = {}

local function workspace_files(root)
    local ls = vim.system({ "git", "-C", root, "ls-files" }, { text = true }):wait()
    local files = {}
    if ls.code == 0 then
        for _, rel in ipairs(vim.split(ls.stdout, "\n", { trimempty = true })) do
            files[#files + 1] = root .. "/" .. rel
        end
        return files
    end
    for name, kind in vim.fs.dir(root, {
        depth = 32,
        skip = function(dir) return not WALK_SKIP[dir] end,
    }) do
        if kind == "file" then
            files[#files + 1] = root .. "/" .. name
        end
    end
    return files
end

-- diagnostics for unopened files; no server supports workspace/diagnostic
local function lsp_load_workspace()
    local buf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = buf })
    if #clients == 0 then
        vim.notify("lsp: no client attached", vim.log.levels.WARN)
        return
    end
    local root = vim.fs.root(buf, ".git") or clients[1].root_dir or vim.uv.cwd()
    vim.notify("lsp: loading workspace files...", vim.log.levels.INFO)
    vim.schedule(function()
        local start = vim.uv.hrtime()
        local loaded = 0
        for _, path in ipairs(workspace_files(root)) do
            local ft = vim.filetype.match({ filename = path })
            if ft and vim.fn.bufnr(path) == -1 and vim.uv.fs_stat(path) then
                for _, client in ipairs(clients) do
                    local sent = opened[client.id] or {}
                    ---@diagnostic disable-next-line: undefined-field
                    if not sent[path] and vim.tbl_contains(client.config.filetypes or {}, ft) then
                        client:notify("textDocument/didOpen", {
                            textDocument = {
                                uri = vim.uri_from_fname(path),
                                languageId = ft,
                                version = 0,
                                text = table.concat(vim.fn.readfile(path), "\n"),
                            },
                        })
                        sent[path] = true
                        opened[client.id] = sent
                        loaded = loaded + 1
                        break
                    end
                end
            end
        end
        local ms = (vim.uv.hrtime() - start) / 1e6
        vim.notify(string.format("lsp: loaded %d files (%.0fms)", loaded, ms), vim.log.levels.INFO)
    end)
end

vim.keymap.set("n", "<leader>cL", lsp_load_workspace, { desc = "lsp: load workspace files" })
