-- Configure Noice UI for signatures and hover docs
return {
    {
        "folke/noice.nvim",
        opts = function(_, opts)

            -- Noice presents: premade on/off features
            opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
                lsp_doc_border  = true,  -- border on LSP hover/signature popups
                command_palette = false, -- cmd prompt at the middle of screen
            })

            -- Noice views: look of each popup type (border, colors, size, position)
            opts.views = vim.tbl_deep_extend("force", opts.views or {}, {
                -- -- Set transparent background for popup and float border
                -- hover = { -- hover: functions signature helps and (K) popups
                --     win_options = { winhighlight = "Normal:Normal,FloatBorder:Normal", },
                -- },
                split = { size = "30%" },
                popup = { size = { width = "70%", height = "60%" } },
            })

            -- Noice routes: where each message routes to
            opts.routes = vim.list_extend(opts.routes or {}, {
                { -- output shell messages to popup (e.g. :!ls, :!make)
                    filter = { event = "msg_show", kind = { "shell_out", "shell_err" } },
                    view = "popup",
                    -- view = "split",
                },
            })

        end,
    },
}
