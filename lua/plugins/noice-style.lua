-- Configure Noice UI for signatures and hover docs
return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      -- Enable borders for LSP popups
      opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
        lsp_doc_border = true,
      })

      -- Apply rounded style and blue diagnostic highlight
      opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
        hover = {
          border = { style = "rounded" },
          win_options = { winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo" },
        },
      })
    end,
  },
}
