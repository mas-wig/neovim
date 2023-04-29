return function()
	local group = vim.api.nvim_create_augroup("PersistedHooks", {})
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "PersistedSavePre",
		group = group,
		callback = function()
			pcall(vim.cmd, "bw minimap")
		end,
	})
	vim.api.nvim_create_autocmd({ "User" }, {
		pattern = "PersistedTelescopeLoadPre",
		group = group,
		callback = function(session)
			print(session.data.branch) -- Print the session's branch
		end,
	})

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
