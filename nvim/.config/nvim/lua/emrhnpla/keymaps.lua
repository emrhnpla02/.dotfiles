local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-A-k>", ":resize +2<CR>", opts)
keymap("n", "<C-A-j>", ":resize -2<CR>", opts)
keymap("n", "<C-A-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-A-h>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- Alternate way to quit or save
keymap("n", "<C-q>", ":bdelete!<CR>", opts)
keymap("n", "<C-s>", ":w<CR>", opts)

-- Insert --

-- Alternate way to quit or save
keymap("i", "<C-q>", "<cmd>:bdelete!<CR>", opts)
keymap("i", "<C-s>", "<cmd>:w<CR>", opts)

-- Press jk or kj fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Disable annoying copy after paste situation
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "<S-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<S-k>", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Plugins --
-- null-ls.nvim
keymap("n", "<C-f>", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
keymap("i", "<C-f>", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)

-- hop.nvim
keymap("n", "f", "<cmd>lua require'hop'.hint_words()<cr>", opts)

-- Comment.nvim
keymap("n", "<C-w>", "<cmd>lua require('Comment.api').toggle_current_linewise()<cr>", opts)
keymap("v", "<C-w>", "<esc><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<cr>", opts)

-- tmux.nvim
keymap("n", "<C-A-h>", "<cmd>lua require('tmux').resize_left()<cr>", opts)
keymap("n", "<C-A-j>", "<cmd>lua require('tmux').resize_bottom()<cr>", opts)
keymap("n", "<C-A-k>", "<cmd>lua require('tmux').resize_top()<cr>", opts)
keymap("n", "<C-A-l>", "<cmd>lua require('tmux').resize_right()<cr>", opts)

-- Symbols-outline.nvim
keymap("n", "<C-o>", "<cmd>SymbolsOutline<cr>", opts)
