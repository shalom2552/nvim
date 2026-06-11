return {
  "milanglacier/minuet-ai.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("minuet").setup({
      virtualtext = {
        enabled = true,
        keymap = {
          accept = "<Tab>",
          accept_line = "<A-a>",
          dismiss = "<Esc>",
        },
      },
      provider = "openai_fim_compatible",
      provider_options = {
        openai_fim_compatible = {
          model = "qwen2.5-coder:7b",
          end_point = "http://localhost:11434/v1/completions",
          api_key = "ollama",
          name = "Ollama",
        },
      },
    })
  end,
}
