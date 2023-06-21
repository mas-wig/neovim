return function()
	local wk = require("which-key")
	vim.o.timeout = true
	vim.o.timeoutlen = 300

	wk.register({
		["<leader>f"] = { name = "+Telescope 󰭎 " },
		["<leader>d"] = { name = "+Debugger  " },
		["<leader>t"] = { name = "+Neotest 󰙨" },
		["<leader>o"] = { name = "+Overseer  " },
		["<leader>x"] = { name = "+Trouble  " },
		["<leader>u"] = { name = "+Toggle stuff  " },
		["<leader>S"] = { name = "+Session  " },
		["<leader>s"] = { name = "+Todo & Spectre 󰬲 " },
		["<leader>gh"] = { name = "+GitSign  " },
		["<leader>b"] = { name = "+Buffer  " },
		["<leader>j"] = { name = "+Grapple 󰙊 " },
		["<A-t>"] = { name = "ToggleTerm  " },
		["<C-g>"] = { name = "Grep word 󰈭 " },
		["<leader><tab>"] = { name = "Tabs 󰓩 " },
	})

	return wk.setup({
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
			border = "none", -- none/single/double/shadow
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
