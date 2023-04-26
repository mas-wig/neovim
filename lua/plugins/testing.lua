return {
	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			{ "antoinemadec/FixCursorHold.nvim", lazy = true },
			{ "nvim-neotest/neotest-go", lazy = true },
		},
		module = { "neotest" },
		config = function()
			for name, icon in pairs(require("ui.icons").neotest) do
				name = "neotest_" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
			require("neotest").setup({
				adapters = {
					require("neotest-go"),
				},
			})
		end,
		init = function()
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
}
