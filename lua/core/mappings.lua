local map = require("setup.utils").map
local Util = require("setup.utils.functions")

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", function()
	vim.ui.input({ prompt = "Buffer ID : " }, function(id)
		if id ~= nil then
			vim.cmd("buffer " .. id)
		end
	end)
end, { desc = "Switch Buffer whit ID" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

map("n", "gw", "*N")
map("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w!<cr>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- stylua: ignore start

-- toggle options
map("n", "<leader>us", function() Util.toggle("spell") end, {desc = "Toggle Spelling"})
map("n", "<leader>uw", function() Util.toggle("wrap") end, {desc = "Toggle Word Wrap"})
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, {desc = "Toggle Line Numbers"})
map("n", "<leader>ud", Util.toggle_diagnostics, {desc = "Toggle Diagnostics"})
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, {desc = "Toggle Conceal"})

-- lazygit
map("n", "<leader>gg", function() Util.float_term({"lazygit"}, {cwd = Util.get_root()}) end, {desc = "Lazygit (root dir)"})
map("n", "<leader>gG", function() Util.float_term({"lazygit"}) end, {desc = "Lazygit (cwd)"})

local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

map("t", "<c-x>", termcodes("<c-\\><c-n>"), {desc = "Enter Normal Mode"})

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", {desc = "Quit all"})

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
    map("n", "<leader>ui", vim.show_pos, {desc = "Inspect Pos"})
end

map("n","<leader>cF", function() Util.ChangeFiletype() end,{ desc = "Change FileType" })
map("t", "<esc><esc>", "<c-\\><c-n>", {desc = "Enter Normal Mode"})

-- windows
map("n", "<leader>ww", "<C-W>p", {desc = "Other window"})
map("n", "<leader>wd", "<C-W>c", {desc = "Delete window"})
-- map("n", "<leader>w-", "<C-W>s", {desc = "Split window below"})
-- map("n", "<leader>w|", "<C-W>v", {desc = "Split window right"})
map("n", "<leader>-", "<C-W>s", {desc = "Split window below"})
map("n", "<leader>|", "<C-W>v", {desc = "Split window right"})

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", {desc = "Last Tab"})
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", {desc = "First Tab"})
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", {desc = "New Tab"})
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", {desc = "Next Tab"})
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", {desc = "Close Tab"})
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", {desc = "Previous Tab"})
