return require("legendary").setup({
	select_prompt = "Legendary",
	include_builtin = false,
	include_legendary_cmds = false,
	which_key = { auto_register = false },
	autocmds = require("core.autocmds"),
	commands = {
		{
			":OpenWithObsidian",
			function()
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
							echo.err("failed opening Obsidian app to note")
						end
					end),
				}):start()
			end,
		},
		{
			":CopyCurrentPathFile",
			function()
				local path = vim.fn.expand("%:p:.")
				vim.fn.setreg("+", path)
				vim.notify('Copied "' .. path .. '" to the clipboard!')
			end,
		},
		{
			":CopyCurrentPathFolder",
			function()
				local path = vim.fn.expand("%:h")
				vim.fn.setreg("+", path)
				vim.notify('Copied "' .. path .. '" to the clipboard!')
			end,
		},
	},
})
