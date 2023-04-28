local M = {}

M.keymaps = function()
	require("legendary").keymaps({
		{
			itemgroup = "NeoTest",
			description = "Test me Daddy",
			icon = "🔭",
			keymaps = {
				{ "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", description = "Attach" },
				{
					"<leader>tf",
					"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
					description = "Run File",
				},
				{
					"<leader>tF",
					"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
					description = "Debug File",
				},
				{ "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>", description = "Run Last" },
				{
					"<leader>tL",
					"<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
					description = "Debug Last",
				},
				{ "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", description = "Run Nearest" },
				{
					"<leader>tN",
					"<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
					description = "Debug Nearest",
				},
				{
					"<leader>to",
					"<cmd>lua require('neotest').output.open({ enter = true })<cr>",
					description = "Output",
				},
				{ "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", description = "Stop" },
				{ "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", description = "Summary" },
			},
		},
	})
end

M.setup = function()
	require("neotest").setup({
		adapters = {
			require("neotest-go"),
		},
		consumers = {
			overseer = require("neotest.consumers.overseer"),
		},
		diagnostic = {
			enabled = false,
		},
		log_level = 1,
		icons = {
			expanded = "",
			child_prefix = "",
			child_indent = "",
			final_child_prefix = "",
			non_collapsible = "",
			collapsed = "",
			passed = " ",
			running = " ",
			failed = " ",
			unknown = " ",
			skipped = " ",
		},
		state = {
			enabled = true,
		},
		status = {
			enabled = true,
			signs = true,
			virtual_text = false,
		},
		floating = {
			border = "single",
			max_height = 0.8,
			max_width = 0.9,
		},
		summary = {
			animated = true,
			enabled = true,
			expand_errors = true,
			follow = true,
			mappings = {
				attach = "a",
				expand = { "<CR>", "<2-LeftMouse>" },
				expand_all = "e",
				jumpto = "i",
				output = "o",
				run = "r",
				short = "O",
				stop = "u",
			},
		},
	})
end

return M
