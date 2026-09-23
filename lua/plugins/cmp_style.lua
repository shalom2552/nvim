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
                    -- cmdline completion menu one line down to live space for borders
                    cmdline_position = function() return vim.g.ui_cmdline_pos or { vim.o.lines - 1, 0 } end,
                },

                -- Documentation popup styling
                documentation = {
                    auto_show = true,
                    window = { border = "rounded", },
                },
            })
        end,

    },
}
