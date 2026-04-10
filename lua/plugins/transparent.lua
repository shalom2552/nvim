-- Transparent background plugin
return {
  "xiyaowong/transparent.nvim",
  lazy = false,

  keys = {
    { "<leader>ut", "<cmd>TransparentToggle<CR>", desc = "Toggle Transparency" },
  },

  opts = {
    exclude_groups = { "CursorLine", "CursorLineNr" },

    -- 2. Add extra groups you want to force to be transparent
    extra_groups = {

      -- Floating windows
      "NormalFloat",
      "FloatBorder",
      "FloatTitle",

      -- Statusline (corner bleed fix)
      "StatusLine",
      "StatusLineNC",

      -- Winbar
      "WinBar",
      "WinBarNC",

      -- Tabline
      "TabLine",
      "TabLineFill",
      "TabLineSel",

      -- Completion menu (blink.cmp / nvim-cmp)
      "Pmenu",
      "PmenuSel",
      "PmenuSbar",
      "PmenuThumb",
      "BlinkCmpMenu",
      "BlinkCmpMenuBorder",
      "BlinkCmpMenuSelection",
      "BlinkCmpDocBorder",
      "BlinkCmpDoc",

      -- Telescope
      "TelescopeNormal",
      "TelescopeBorder",
      "TelescopePromptBorder",
      "TelescopeResultsBorder",
      "TelescopePreviewBorder",

      -- Snacks windows
      "SnacksNormal",
      "SnacksNormalNC",
      "SnacksWinBar",
      "SnacksWinBarNC",
      "SnacksWinSeparator",
      "SnacksTitle",
      "SnacksFooter",
      "SnacksFooterDesc",
      "SnacksFooterKey",
      "SnacksBackdrop",

      -- Snacks dashboard
      "SnacksDashboardNormal",

      -- Snacks picker
      "SnacksPicker",
      "SnacksPickerBorder",
      "SnacksPickerBox",
      "SnacksPickerBoxBorder",
      "SnacksPickerBoxFooter",
      "SnacksPickerBoxTitle",
      "SnacksPickerList",
      "SnacksPickerListBorder",
      "SnacksPickerListTitle",
      "SnacksPickerListFooter",
      "SnacksPickerPreview",
      "SnacksPickerPreviewBorder",
      "SnacksPickerPreviewTitle",
      "SnacksPickerPreviewFooter",
      "SnacksPickerInput",
      "SnacksPickerInputBorder",
      "SnacksPickerInputTitle",
      "SnacksPickerInputFooter",
      "SnacksPickerTitle",
      "SnacksPickerFooter",
      "SnacksPickerPrompt",

      -- Snacks input
      "SnacksInputNormal",
      "SnacksInputBorder",
      "SnacksInputTitle",

      -- Snacks notifier
      "SnacksNotifierTrace",
      "SnacksNotifierBorderTrace",
      "SnacksNotifierTitleTrace",
      "SnacksNotifierInfo",
      "SnacksNotifierBorderInfo",
      "SnacksNotifierTitleInfo",
      "SnacksNotifierWarn",
      "SnacksNotifierBorderWarn",
      "SnacksNotifierTitleWarn",
      "SnacksNotifierDebug",
      "SnacksNotifierBorderDebug",
      "SnacksNotifierTitleDebug",
      "SnacksNotifierError",
      "SnacksNotifierBorderError",
      "SnacksNotifierTitleError",
      "SnacksNotifierHistory",
      "SnacksNotifierHistoryTitle",

      -- Noice (cmdline popup, notifications)
      "NoiceCmdlinePopup",
      "NoiceCmdlinePopupBorder",
      "NoiceCmdlineIcon",
      "NoicePopupmenu",
      "NoicePopupmenuBorder",
      "NoiceMini",
      "NoiceScrollbar",
      "NoiceScrollbarThumb",

      -- Which-key
      "WhichKeyFloat",
      "WhichKeyBorder",
      "WhichKeyNormal",

      -- Lazy.nvim UI
      "LazyNormal",
      "LazyBackdrop",

      -- Mason
      "MasonNormal",

      -- nvim-notify
      "NotifyBackground",
      "NotifyERRORBody",
      "NotifyWARNBody",
      "NotifyINFOBody",
      "NotifyDEBUGBody",
      "NotifyTRACEBody",
      "NotifyERRORBorder",
      "NotifyWARNBorder",
      "NotifyINFOBorder",
      "NotifyDEBUGBorder",
      "NotifyTRACEBorder",

      -- File explorer (NeoTree fallback)
      "NeoTreeNormal",
      "NeoTreeNormalNC",

      -- LSP / diagnostics popups
      "LspInfoBorder",

      -- Indent guides (mini.indentscope)
      "MiniIndentscopeSymbol",
    },
  },
}
