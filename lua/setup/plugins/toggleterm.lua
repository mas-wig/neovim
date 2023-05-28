require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 13
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.35
		end
	end,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	autochdir = true,
	highlights = {
		FloatBorder = {
			guifg = require("setup.ui.colors").line,
			guibg = "none",
		},
	},
	shade_terminals = true,
	start_in_insert = true,
	insert_mappings = true,
	terminal_mappings = true,
	persist_size = true,
	persist_mode = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "rounded",
		width = 145,
		height = 20,
		winblend = 0,
	},
	winbar = {
		enabled = false,
	},
})
