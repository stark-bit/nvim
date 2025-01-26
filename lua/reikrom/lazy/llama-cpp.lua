return {
  'ggml-org/llama.vim',
  init = function()
    vim.g.llama_config = {
      --  auto_fim = false,
      show_info = false
    }

    vim.keymap.set("n", "<leader>le", function()
      vim.g.llama_config.auto_fim = true -- Modify the field directly
      print("Llama Enabled")
    end)
  end,
}
