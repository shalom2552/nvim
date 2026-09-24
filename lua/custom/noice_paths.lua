-- custom/noice_paths.lua (own module, loaded from config/autocmds.lua)
-- In noice windows (e.g. :!ls, :!make output): highlight paths that exist on disk
-- (files green, dirs blue, file:line:col supported) and open them with <CR>.

local ns = vim.api.nvim_create_namespace("noice_fileloc")

-- underlined path links: files green, dirs blue (colors follow the colorscheme)
local function set_loc_hls()
  local function fg(group)
    return vim.api.nvim_get_hl(0, { name = group, link = false }).fg
  end
  vim.api.nvim_set_hl(0, "NoiceFileLoc", { fg = fg("String"), underline = true })
  vim.api.nvim_set_hl(0, "NoiceDirLoc", { fg = fg("Directory"), underline = true })
end
set_loc_hls()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_loc_hls })

local LOC_HL = { file = "NoiceFileLoc", directory = "NoiceDirLoc" }

-- "file" | "directory" | nil
local function path_kind(path, cache)
  if cache and cache[path] ~= nil then
    return cache[path] or nil
  end
  local stat = vim.uv.fs_stat(path)
  local kind = stat and LOC_HL[stat.type] and stat.type or false
  if cache then
    cache[path] = kind
  end
  return kind or nil
end

-- "src/main.c:10:5:" -> "src/main.c", "10", "5", matched length, kind; nil if path not on disk
local function parse_loc(token, cache)
  local file, line, col = token:match("^([^:]+):?(%d*):?(%d*)")
  local kind = file and path_kind(file, cache)
  if not kind then
    return nil
  end
  local len = #file + (line ~= "" and #line + 1 or 0) + (col ~= "" and #col + 1 or 0)
  return file, line, col, len, kind
end

local function highlight_locs(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local cache = {}
  for lnum, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for start, token in text:gmatch("()(%S+)") do
      local _, _, _, len, kind = parse_loc(token, cache)
      if len then
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, start - 1, {
          end_col = start - 1 + len,
          hl_group = LOC_HL[kind],
          -- above noice's own line highlight (default 4096)
          priority = 5000,
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "noice",
  callback = function(ev)
    local buf = ev.buf
    local pending = false
    -- noice writes lines in bursts; rescan once per burst
    local function schedule_highlight()
      if pending then
        return
      end
      pending = true
      vim.schedule(function()
        pending = false
        highlight_locs(buf)
      end)
    end
    schedule_highlight()
    vim.api.nvim_buf_attach(buf, false, { on_lines = schedule_highlight })

    vim.keymap.set("n", "<CR>", function()
      local file, line, col, _, kind = parse_loc(vim.fn.expand("<cWORD>"))
      if not file then
        return
      end
      vim.cmd("close")
      vim.cmd.edit(vim.fn.fnameescape(file))
      if kind == "file" and line ~= "" then
        vim.api.nvim_win_set_cursor(0, { tonumber(line), col ~= "" and tonumber(col) - 1 or 0 })
      end
    end, { buffer = buf })
  end,
})
