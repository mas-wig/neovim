return function()
	vim.o.timeout = true
	vim.o.timeoutlen = 300
	return require("which-key").setup({
		icons = {

			breadcrumb = " 🌐",
			separator = " 🡆 ",
			group = "🔰 ",
		},
		popup_mappings = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
		window = {
			border = "single", -- none/single/double/shadow
		},
		layout = {
			spacing = 6, -- spacing between columns
		},
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
		triggers_blacklist = {
			i = { "j", "k" },
			v = { "j", "k" },
		},
	})
end
