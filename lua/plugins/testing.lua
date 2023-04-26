return {
	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			{ "antoinemadec/FixCursorHold.nvim", lazy = true },
			{ "nvim-neotest/neotest-go", lazy = true },
		},
		config = function()
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
		end,
		init = function()
			require("legendary").commands({
				{
					itemgroup = "Neotest",
					icon = "省",
					description = "Task running functionality...",
					commands = {
						{
							":NeotestRunNearest",
							function()
								require("neotest").run.run()
							end,
							description = "Run Nearest",
						},
					},
				},
			})

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
		end,
	},

	{
		"stevearc/overseer.nvim", -- Task runner and job management
		lazy = true,
		opts = {
			component_aliases = {
				default_neotest = {
					"on_output_summarize",
					"on_exit_set_status",
					"on_complete_dispose",
				},
			},
		},
		init = function()
			require("legendary").commands({
				{
					itemgroup = "Overseer",
					icon = "省",
					description = "Task running functionality...",
					commands = {
						{
							":OverseerRun",
							description = "Run a task from a template",
						},
						{
							":OverseerBuild",
							description = "Open the task builder",
						},
						{
							":OverseerToggle",
							description = "Toggle the Overseer window",
						},
					},
				},
			})
			require("legendary").keymaps({
				itemgroup = "Overseer",
				keymaps = {
					{
						"<Leader>o",
						function()
							local overseer = require("overseer")
							local tasks = overseer.list_tasks({ recent_first = true })
							if vim.tbl_isempty(tasks) then
								vim.notify("No tasks found", vim.log.levels.WARN)
							else
								overseer.run_action(tasks[1], "restart")
							end
						end,
						description = "Run the last Overseer task",
					},
				},
			})
		end,
	},
}
