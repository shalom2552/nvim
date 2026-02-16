-- Sets rounded borders and blue highlights for blink.cmp windows
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      -- Merge settings safely to force the override
      opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
        -- Main completion menu styling
        menu = {
          border = "rounded",
          winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo,CursorLine:Visual",
        },
        -- Documentation popup styling
        documentation = {
          auto_show = true,
          window = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo",
          },
        },
      })
    end,
  },
}
