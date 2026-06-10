  -- install markdown-preview.nvim without yarn or npm
  -- :Lazy build markdown-preview.nvim
  return {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = ":call mkdp#util#install()",
  }
