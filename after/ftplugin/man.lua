-- Manpage configurations
vim.opt_local.statuscolumn = ""
vim.opt_local.textwidth = 0

-- Handle cpp ref links follow
local function follow()
  local page = vim.api.nvim_buf_get_name(0):match("^man://(std::[^(]+)%(")
  if page then
    local class = page:match("^std::[%w_]+")
    local seen = {}
    for _, word in ipairs({ vim.fn.expand("<cWORD>"), vim.fn.expand("<cword>") }) do
      for _, name in ipairs({ class .. "::" .. word, "std::" .. word }) do
        if not seen[name] then
          seen[name] = true
          vim.fn.system({ "man", "-w", name })
          if vim.v.shell_error == 0 then
            vim.cmd("Man " .. vim.fn.fnameescape(name))
            return
          end
        end
      end
    end
  end
  vim.api.nvim_feedkeys(vim.keycode("<C-]>"), "n", false)
end

vim.keymap.set("n", "<CR>",          follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "K",             follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<C-]>",         follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<2-LeftMouse>", follow, { buffer = true, desc = "Follow man reference" })
vim.keymap.set("n", "<BS>", "<C-t>", { buffer = true, desc = "Back to previous man page" })
