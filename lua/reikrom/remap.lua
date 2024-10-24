vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>vwm", function()
--    require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--    require("vim-with-me").StopVimWithMe()
-- end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- quick yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- deletes ?
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
-- nice
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word at current position globally with regex
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- make the file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
-- make the file executable
-- vim.keymap.set("n", "<leader><leader>w", "<cmd>:w<CR>", { silent = true })
 vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>", { silent = true })

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/reikrom/packer.lua<CR>");
-- when thinking gets thought, relax with mr1 and mr2
vim.keymap.set("n", "<leader>mr1", "<cmd>CellularAutomaton make_it_rain<CR>");
vim.keymap.set("n", "<leader>mr2", "<cmd>CellularAutomaton game_of_life<CR>");

-- this is a nice shortcut
vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
-- change nvim pwd to currently open files dir
vim.keymap.set("n", '<leader>cd', [[:cd %:p:h<CR>:pwd<CR>"<cmd>%:p:h<CR>:pwd<CR>]])

-- for JS
vim.keymap.set("n", "<leader>rlg", "oconsole.log('rei ");
-- for Go
vim.keymap.set("n", "<leader>ee", "o if err != nil {<CR>return err<CR>}<CR><C-c>kk$");

-- run prettier on staged files
vim.keymap.set("n", "<leader>pw", "<cmd>!npx prettier --write $(git diff --cached --name-only --diff-filter=ACMRTUXB | xargs)<CR>", { silent = true })
