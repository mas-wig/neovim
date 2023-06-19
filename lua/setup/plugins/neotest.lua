local M = {}

M.keys = {
	{
		"<leader>tF",
		function()
			require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
		end,
		desc = "Debug File",
	},
	{
		"<leader>tL",
		function()
			require("neotest").run.run_last({ strategy = "dap" })
		end,
		desc = "Debug Last",
	},
	{
		"<leader>ta",
		function()
			require("neotest").run.attach()
		end,
		desc = "Attach",
	},
	{
		"<leader>tf",
		function()
			require("neotest").run.run(vim.fn.expand("%"))
		end,
		desc = "File",
	},
	{
		"<leader>tl",
		function()
			require("neotest").run.run_last()
		end,
		desc = "Last",
	},
	{
		"<leader>tn",
		function()
			require("neotest").run.run()
		end,
		desc = "Nearest",
	},
	{
		"<leader>tN",
		function()
			require("neotest").run.run({ strategy = "dap" })
		end,
		desc = "Debug Nearest",
	},
	{
		"<leader>to",
		function()
			require("neotest").output.open({ enter = true })
		end,
		desc = "Output",
	},
	{
		"<leader>ts",
		function()
			require("neotest").run.stop()
		end,
		desc = "Stop",
	},
	{
		"<leader>tS",
		function()
			require("neotest").summary.toggle()
		end,
		desc = "Summary",
	},
}

M.setup = function()
	local neotest_ns = vim.api.nvim_create_namespace("neotest")
	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
				return message
			end,
		},
	}, neotest_ns)

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
