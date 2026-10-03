-- Auto-show blink.cmp documentation popup
return {
    {
        "saghen/blink.cmp",

        opts = function(_, opts)

            -- Merge settings safely to force the override
            opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {

                -- Documentation popup
                documentation = {
                    auto_show = true,
                },

            })

        end,

    },
}
