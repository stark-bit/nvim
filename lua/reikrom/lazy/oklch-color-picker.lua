return {
  "eero-lehtinen/oklch-color-picker.nvim",
  event = "VeryLazy",
  -- v5 requires Neovim 0.12+.
  version = "^4",
  keys = {
    -- One handed keymap recommended, you will be using the mouse
    {
      "<leader>v",
      function() require("oklch-color-picker").pick_under_cursor() end,
      desc = "Color pick under cursor",
    },
  },
  ---@type oklch.Opts
  opts = {},
}
