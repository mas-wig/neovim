local M = {}

M.setup = function()
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
				guifg = require("setup.ui.colors").green,
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

local run_cmd = {
	go = "run",
	javascript = "node",
}

local run_serve = {
	go = "air main.go",
}

M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "ToggleTerm",
			description = "Term me Daddy",
			icon = "🔭",
			keymaps = {
				{
					"<A-i>",
					{
						n = "<cmd>ToggleTerm direction=float cwd='" .. os.getenv("PWD") .. "'<cr>",
						t = "<cmd>ToggleTerm direction=float  cwd='" .. os.getenv("PWD") .. "'<cr>",
					},
					desc = "Open Float Term",
				},
				{
					"<A-v>",
					{
						n = "<cmd>ToggleTerm direction=vertical cwd='" .. os.getenv("PWD") .. "'<cr>",
						t = "<cmd>ToggleTerm direction=vertical  cwd='" .. os.getenv("PWD") .. "'<cr>",
					},
					desc = "Open Vert Term",
				},
				{
					"<A-h>",
					{
						n = "<cmd>ToggleTerm direction=horizontal  cwd='" .. os.getenv("PWD") .. "'<cr>",
						t = "<cmd>ToggleTerm direction=horizontal  cwd='" .. os.getenv("PWD") .. "'<cr>",
					},
					desc = "Open Horz Term",
				},
				{
					"<leader>rc",
					function(ft)
						ft = vim.bo.filetype
						for lang, cmd in pairs(run_cmd) do
							if ft == lang then
								vim.cmd(
									"TermExec direction=float cmd='"
										.. tostring(lang)
										.. " "
										.. cmd
										.. " "
										.. tostring(vim.fn.expand("%:p:."))
										.. "'"
								)
							end
						end
					end,
					desc = "Run Code",
				},
				{
					"<leader>rs",
					function(ft)
						ft = vim.bo.filetype
						for lang, cmd in pairs(run_serve) do
							if ft == lang then
								vim.cmd("TermExec direction=float cmd='" .. cmd .. "' open=0")
							end
						end
					end,
					desc = "Run Serve",
				},
			},
		},
	})
end

return M
