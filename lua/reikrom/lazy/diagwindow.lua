return {
  "cseickel/diagnostic-window.nvim",
  requires = { "MunifTanjim/nui.nvim" },
  config = function()
    vim.keymap.set("n", "gK", "<cmd>DiagWindowShow<CR>")
  end
}
