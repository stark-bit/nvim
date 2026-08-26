return {
  "pablopunk/pi.nvim",
  opts = {
    provider = "github-copilot",
    model = "gpt-5.6-luna",
    extensions = false,
  },
  keys = {
    { "<leader>pi", "<cmd>PiAsk<cr>", mode = "n", desc = "Ask pi" },
    { "<leader>pI", "<cmd>PiAskSelection<cr>", mode = "v", desc = "Ask pi selection" },
    { "<leader>pc", "<cmd>PiCancel<cr>", mode = "n", desc = "Cancel pi" },
  },
  config = function(_, opts)
    require("pi").setup(opts)
  end,
}
