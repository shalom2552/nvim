return {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
        vim.keymap.set("n", "<leader>at", "<cmd>Minuet virtualtext toggle<cr>", { desc = "Toggle Minuet" })
    end,
    opts = {
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 2048,
        throttle = 500,
        debounce = 300,
        request_timeout = 15,
        provider_options = {
            openai_fim_compatible = {
                api_key = "TERM",
                name = "Ollama",
                end_point = "http://localhost:11434/v1/completions",
                model = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:1.5b",
                stream = false,
                optional = {
                    max_tokens = 256,
                    top_p = 0.9,
                    temperature = 0.1,
                },
            },
        },
        virtualtext = {
            auto_trigger_ft = {"*"},
            keymap = {
                accept = "<A-y>",
                accept_line = "<A-a>",
                next = "<C-n>",
                prev = "<C-p>",
                dismiss = "<C-e>",
            },
        },
    },
}
