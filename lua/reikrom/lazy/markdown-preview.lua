  -- install markdown-preview.nvim without yarn or npm
  -- :Lazy build markdown-preview.nvim
  vim.g.mkdp_highlight_css = vim.fn.stdpath("config") .. "/markdown-preview-highlight.css"

  return {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = ":call mkdp#util#install()",
  }
