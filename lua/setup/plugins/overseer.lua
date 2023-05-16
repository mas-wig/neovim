local M = {}

M.init = function()
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

	require("legendary").commands({
		{
			"OverseerRestartLast",
			function()
				local overseer = require("overseer")
				local tasks = overseer.list_tasks({ recent_first = true })
				if vim.tbl_isempty(tasks) then
					vim.notify("No tasks found", vim.log.levels.WARN)
				else
					overseer.run_action(tasks[1], "restart")
				end
			end,
			hide = true,
		},
	})

	require("legendary").keymaps({
		itemgroup = "Overseer",
		icon = "🗿",
		description = "Over me daddy... :) ",
		keymaps = {
			{ "<Leader>ok", "<cmd>OverseerRestartLast<cr>", desc = "Run the last Overseer task" },
			{ "<leader>oC", "<cmd>OverseerClose<cr>", desc = "Overseer Close" },
			{ "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer Task Action" },
			{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
			{ "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Overseer Run Cmd" },
			{ "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Overseer Delete Bundle" },
			{ "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "Overseer Load Bundle" },
			{ "<leader>oo", "<cmd>OverseerOpen!<cr>", desc = "Overseer Open" },
			{ "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer Quick Action" },
			{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
			{ "<leader>os", "<cmd>OverseerSaveBundle<cr>", desc = "Overseer Save Bundle" },
			{ "<leader>ot", "<cmd>OverseerToggle!<cr>", desc = "Overseer Toggle" },
		},
	})
end

return M
