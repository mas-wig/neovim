vim.api.nvim_create_user_command("OpenWithObsidian", function()
	local Job = require("plenary.job")
	local uri = ("obsidian://open?vault=%s&path=%s"):format(
		"NOTES",
		string.gsub(tostring(vim.api.nvim_buf_get_name(0)), "/", "%%2F")
	)
	Job:new({
		command = "xdg-open",
		args = { uri },
		on_exit = vim.schedule_wrap(function(_, return_code)
			if return_code > 0 then
				vim.api.nvim_err_writeln("Failed opening Obsidian app to note")
			end
		end),
	}):start()
end, {})

vim.api.nvim_create_user_command("CopyCurrentPathFile", function()
	local path = vim.fn.expand("%:p:.")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("CopyCurrentPathFolder", function()
	local path = vim.fn.expand("%:h")
	vim.fn.setreg("+", path)
	vim.notify('Copied "' .. path .. '" to the clipboard!')
end, {})

vim.api.nvim_create_user_command("OverseerRestartLast", function()
	local overseer = require("overseer")
	local tasks = overseer.list_tasks({ recent_first = true })
	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)
	else
		overseer.run_action(tasks[1], "restart")
	end
end, {})

vim.api.nvim_create_user_command("LspStopAll", function()
	local bufnrs = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(bufnrs) do
		local clients = vim.lsp.buf_get_clients(bufnr)
		for _, client in ipairs(clients) do
			vim.lsp.stop_client(client.id)
		end
	end
	vim.notify("Lsp server killed on attached buffers", vim.log.levels.INFO)
end, {})
