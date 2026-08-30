return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup()
        vim.treesitter.language.register("templ", "templ")

        require("nvim-treesitter").install({ "svelte", "templ", "lua", "vim", "vimdoc", "javascript" })

        vim.keymap.set("n", "<leader>ta", function()
            vim.print(vim.tbl_keys(require('nvim-treesitter.parsers')))
        end, { desc = "list parsers" })
    end
}
