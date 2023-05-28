local M = {}
M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "ToggleTerm",
			description = "Toggle me Daddy",
			icon = "🔭",
			keymaps = {
				{ "<A-i>", "<cmd>ToggleTerm direction=float<cr>", description = "Open Float Term" },
				{ "<A-v>", "<cmd>ToggleTerm direction=vertical<cr>", description = "Open Vert Term" },
				{ "<A-h>", "<cmd>ToggleTerm direction=horizontal<cr>", description = "Open Horz Term" },
				{
					"<A-i>",
					{
						n = "<cmd>ToggleTerm direction=float<cr>",
						t = "<cmd>ToggleTerm direction=float<cr>",
					},
					description = "Open Float Term",
				},
				{
					"<A-v>",
					{
						n = "<cmd>ToggleTerm direction=vertical<cr>",
						t = "<cmd>ToggleTerm direction=vertical<cr>",
					},
					description = "Open Vert Term",
				},
				{
					"<A-h>",
					{
						n = "<cmd>ToggleTerm direction=horizontal<cr>",
						t = "<cmd>ToggleTerm direction=horizontal<cr>",
					},
					description = "Open Horz Term",
				},
			},
		},
	})
end

M.setup = function()
	return require("toggleterm").setup({
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
				guifg = require("setup.ui.colors").purple,
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
end

return M
