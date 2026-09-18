local M = {}

-- run a command, nil if it is missing, fails or hangs
local function run(cmd, env)
  local ok, res = pcall(function()
    return vim.system(cmd, { text = true, env = env, timeout = 10000 }):wait()
  end)
  if not ok or res.code ~= 0 then return nil end
  return res.stdout
end

-- directory that holds the cppman pages, taken from the page we are reading
local cache
local function cache_dir(page)
  if not cache then
    local out = run({ "man", "-w", page })
    cache = out and vim.fn.fnamemodify(vim.trim(out), ":h") or nil
  end
  return cache
end

-- drop template parameters so std::vector<T,Allocator>::at becomes std::vector::at
local function strip_templates(name)
  local out = name
  for _ = 1, 4 do
    local shorter = out:gsub("<[^<>]*>", "")
    if shorter == out then break end
    out = shorter
  end
  return out
end

-- split a page title on the commas that separate names, not the ones inside <>
local function split_names(title)
  local out, depth, start = {}, 0, 1
  for i = 1, #title do
    local c = title:sub(i, i)
    if c == "<" then
      depth = depth + 1
    elseif c == ">" then
      depth = math.max(depth - 1, 0)
    elseif c == "," and depth == 0 then
      out[#out + 1] = title:sub(start, i - 1)
      start = i + 1
    end
  end
  out[#out + 1] = title:sub(start)
  return out
end

-- a page shared by one class carries that class in parentheses
local function split_owner(title)
  local name, owner = title:match("^(.-)%s*%((std::[^()]*)%)$")
  return name or title, owner
end

-- every name this page answers to, so a word on another page can find it
local function keys_of(title)
  local name = split_owner(title)
  if name:find("^operator") or name:find("^std::operator") then return { "operator" } end

  -- a member operator page lists its operators after the class,
  -- as in std::bitset<N>::operator&=,|=,^=,~
  local class, ops = name:match("^(.-)::(operator[^%w%s].*)$")
  if class then
    local keys = {}
    for _, op in ipairs(vim.split(ops, ",", { plain = true })) do
      op = vim.trim(op)
      if op:find("::") then
        keys[#keys + 1] = strip_templates(op)
      elseif op ~= "" then
        keys[#keys + 1] = strip_templates(class) .. "::" .. (op:find("^operator") and op or "operator" .. op)
      end
    end
    return keys
  end

  local keys, prefix = {}, nil
  for i, part in ipairs(split_names(name)) do
    local element = strip_templates(vim.trim(part))
    if element ~= "" then
      if i == 1 then
        prefix = element:match("^(.*)::[^:]+$")
        -- a very long title is cut short on disk, so claim the class as a last resort
        if prefix and title:find("%-%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$") then
          keys[#keys + 1] = prefix .. "::*"
        end
      end
      if not element:find("::") and prefix then
        element = prefix .. "::" .. element
      end
      keys[#keys + 1] = element
      -- shorter tails too, so views::single still finds std::ranges::views::single
      local tail = element
      while true do
        tail = tail:match("^[^:]+::(.+)$")
        if not tail or not tail:find("::") then break end
        keys[#keys + 1] = tail
      end
    end
  end
  return keys
end

-- one pass over the cache directory, kept for the rest of the session
local index
local function build(page)
  local dir = cache_dir(page)
  if not dir then return false end
  index = {}
  for _, fname in ipairs(vim.fn.readdir(dir)) do
    local title = fname:match("^(.*)%.3%.gz$")
    if title then
      local _, owner = split_owner(title)
      for _, key in ipairs(keys_of(title)) do
        index[key] = index[key] or {}
        table.insert(index[key], { title = title, owner = owner })
      end
    end
  end
  return true
end

-- every std:: prefix of the page, longest first, so nested namespaces still match
local function class_candidates(page)
  local parts = {}
  for part in strip_templates(page):gmatch("[^:]+") do
    parts[#parts + 1] = part
  end
  local out = {}
  for n = #parts, 2, -1 do
    out[#out + 1] = table.concat(parts, "::", 1, n)
  end
  return out
end

-- a page owned by the class we came from beats one owned by anything else
local function pick(entries, classes)
  for _, class in ipairs(classes) do
    for _, entry in ipairs(entries) do
      if entry.owner == class then return entry.title end
    end
  end
  for _, entry in ipairs(entries) do
    if not entry.owner and not entry.title:find("<bool", 1, true) then return entry.title end
  end
  return entries[1].title
end

-- the window title is cut short, so take the page name from the NAME section
function M.current_page()
  for i, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 10, false)) do
    if line:match("^NAME%s*$") then
      local first = (vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1] or ""):match("%S+")
      return first and first:gsub("[,%s]+$", "")
    end
  end
end

-- turn a word from the page into the title of the page it points at
function M.resolve(page, word)
  if not index and not build(page) then return nil end

  local classes = class_candidates(page)
  if #classes == 0 then return nil end

  -- the member tables call these two by role instead of by name
  if word == "(constructor)" or word == "(destructor)" then
    local own = classes[1]:match("[^:]+$")
    word = (word == "(destructor)" and "~" or "") .. own
  end

  local keys = {}
  if word:find("^std::") then
    keys[#keys + 1] = word
  else
    for _, class in ipairs(classes) do
      keys[#keys + 1] = class .. "::" .. word
    end
    keys[#keys + 1] = "std::" .. word
    keys[#keys + 1] = word
  end
  if word:find("^operator") then
    keys[#keys + 1] = "operator"
  end
  for _, class in ipairs(classes) do
    keys[#keys + 1] = class .. "::*"
  end

  for _, key in ipairs(keys) do
    if index[key] then return pick(index[key], classes) end
  end
  return nil
end

-- :Man cannot parse these titles, so render the page and hand it to the man plugin
function M.open(title)
  local rendered = run({ "man", title }, {
    MANPAGER = "cat",
    MAN_KEEP_FORMATTING = "1",
    MANWIDTH = tostring(vim.api.nvim_win_get_width(0)),
  })
  if not rendered then return false end

  local win = vim.api.nvim_get_current_win()
  local from = { vim.api.nvim_get_current_buf(), vim.fn.line("."), vim.fn.col("."), 0 }
  vim.cmd("enew")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(rendered, "\n"))
  require("man").init_pager()
  vim.fn.settagstack(win, { items = { { tagname = title, from = from } } }, "t")
  return true
end

-- follow the reference under the cursor, false if this is not a cppman page
function M.follow()
  local page = M.current_page()
  if not page or not page:find("^std::") then return false end

  local word = vim.fn.expand("<cword>")
  -- the page writes refs like erase_if(std::vector) and max()).
  local bare = word:gsub("%b()", ""):gsub("^[^%w_~]+", ""):gsub("[%)%.,;:]+$", "")
  local words = { vim.fn.expand("<cWORD>"), word, bare }
  -- names like "operator bool" are two words on the page
  local before = vim.api.nvim_get_current_line():sub(1, vim.api.nvim_win_get_cursor(0)[2] + 1)
  if before:match("operator%s+%S*$") then
    table.insert(words, 1, "operator " .. bare)
  end

  for _, name in ipairs(words) do
    local title = name ~= "" and M.resolve(page, name)
    if title and M.open(title) then return true end
  end
  return false
end

return M
