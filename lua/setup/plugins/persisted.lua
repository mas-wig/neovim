return function()
	require("legendary").keymaps({
		{
			itemgroup = "Persisted",
			icon = "",
			description = "Session management...",
			keymaps = {
				{
					"<Leader>s",
					'<cmd>lua require("persisted").toggle()<CR>',
					description = "Toggle a session",
					opts = { silent = true },
				},
			},
		},
	})
	require("legendary").commands({
		{
			itemgroup = "Persisted",
			commands = {
				{
					":Sessions",
					function()
						vim.cmd([[Telescope persisted]])
					end,
					description = "List sessions",
				},
				{
					":SessionSave",
					description = "Save the session",
				},
				{
					":SessionStart",
					description = "Start a session",
				},
				{
					":SessionStop",
					description = "Stop the current session",
				},
				{
					":SessionLoad",
					description = "Load the last session",
				},
				{
					":SessionDelete",
					description = "Delete the current session",
				},
			},
		},
	})
end
