return {
  'ggml-org/llama.vim',
  init = function()
    vim.g.llama_config = {
      auto_fim = false, -- Ctrl+F + server has to be running
      show_info = false
    }
  end,
}
