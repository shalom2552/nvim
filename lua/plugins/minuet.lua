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
        throttle = 50,
        debounce = 30,
        request_timeout = 15,
        provider_options = {
            openai_fim_compatible = {
                api_key = "TERM",
                name = "Ollama",
                end_point = "http://localhost:11434/v1/completions",
                model = os.getenv("OLLAMA_MODEL") or "qwen2.5-coder:1.5b",
                stream = true,
                optional = {
                    max_tokens = 64,
                    top_p = 0.9,
                    temperature = 0.1,
                    stop = {
                        "<|endoftext|>",
                        "<|fim_prefix|>",
                        "<|fim_middle|>",
                        "<|fim_suffix|>",
                        "<|fim_pad|>",
                        "\n\n", -- Stops generation at double blank lines
                    },
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
