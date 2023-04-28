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
end

return M
