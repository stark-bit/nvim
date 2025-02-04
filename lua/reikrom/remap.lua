vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- quick yank
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- deletes ?
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- make the file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>", { silent = true })
-- nice
vim.keymap.set("i", "<C-c>", "<Esc>")
-- exec curr file
 vim.keymap.set("n", "<leader><leader>", function()
   vim.cmd("so")
   end)

vim.keymap.set("n", "Q", "<C-w>q")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word at current position globally with regex
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/reikrom/packer.lua<CR>");
-- when thinking gets thought, relax with mr1 and mr2
vim.keymap.set("n", "<leader>mr1", "<cmd>CellularAutomaton make_it_rain<CR>");
vim.keymap.set("n", "<leader>mr2", "<cmd>CellularAutomaton game_of_life<CR>");

-- command in curr buffer's dir
vim.keymap.set("n", "<leader>dc", ":! (cd %:p:h && )<Left>");


-- run prettier on staged files and current buff file
vim.keymap.set("n", "<leader>pwc",
  "<cmd>!npx prettier --write $(git diff --cached --name-only --diff-filter=ACMRTUXB | xargs)<CR>", { silent = true })
vim.keymap.set("n", "<leader>pwf", "<cmd>!npx prettier --write %:p<CR>", { silent = true })


vim.keymap.set('n', '<C-z>', '<Nop>')
