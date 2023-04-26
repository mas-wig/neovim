local statusline = {}

statusline.conditions = require("heirline.conditions")

statusline.spacer_left = {
	-- provider = "  ",
	provider = "  ",
	hl = function()
		return { fg = "yellow" }
	end,
}

statusline.spacer_right = {
	-- provider = "  ",
	provider = "  ",
	hl = function()
		return { fg = "yellow" }
	end,
}

statusline.stl_static = {
	mode_color_map = {
		n = "blue",
		i = "green",
		v = "purple",
		V = "purple",
		["\22"] = "purple",
		c = "yellow",
		s = "purple",
		S = "purple",
		["\19"] = "purple",
		R = "red",
		r = "red",
		["!"] = "orange",
		t = "orange",
	},
	mode_color = function(self)
		local mode = vim.fn.mode(1):sub(1, 1)
		return self.mode_color_map[mode]
	end,
}

statusline.vimMode = {
	init = function(self)
		self.mode = vim.fn.mode(1)
		if not self.once then
			vim.api.nvim_create_autocmd("ModeChanged", {
				pattern = "*:*o",
				command = "redrawstatus",
			})
			self.once = true
		end
	end,
	static = {
		mode_names = {
			n = "NORMAL",
			no = "NORMAL-",
			nov = "NORMAL-",
			noV = "NORMAL-",
			["no\22"] = "NORMAL-",
			niI = "NORMAL-",
			niR = "NORMAL-",
			niV = "NORMAL-",
			nt = "NORMAL-",
			v = "VISUAL",
			vs = "VISUAL-",
			V = "V-LINE",
			Vs = "V-LINE-",
			["\22"] = "V-BLOCK",
			["\22s"] = "V-BLOCK-",
			s = "SELECT",
			S = "S-LINE",
			["\19"] = "S-BLOCK",
			i = "INSERT",
			ic = "INSERT-",
			ix = "INSERT-",
			R = "REPLACE",
			Rc = "REPLACE-",
			Rx = "REPLACE-",
			Rv = "REPLACE-",
			Rvc = "REPLACE-",
			Rvx = "REPLACE-",
			c = "COMMAND",
			cv = "COMMAND-",
			r = "PROMPT",
			rm = "MORE",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			t = "TERMINAL",
		},
	},
	provider = function(self)
		return " " .. self.mode_names[self.mode]
	end,
	hl = function(self)
		return { fg = self:mode_color(), bg = "bg" }
	end,
	update = {
		"ModeChanged",
	},
	statusline.spacer_right,
}

statusline.fileLastModified = {
	provider = function()
		local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
		return (ftime > 0) and os.date("%c", ftime)
	end,
	hl = function()
		return { fg = "yellow" }
	end,
}

statusline.lazy = {
	condition = function(self)
		return not statusline.conditions.buffer_matches({
			filetype = self.filetypes,
		}) and require("lazy.status").has_updates()
	end,
	provider = function()
		return "Lazy " .. require("lazy.status").updates()
	end,
	on_click = {
		callback = function()
			require("lazy").update()
		end,
		name = "update_plugins",
	},
	hl = { fg = "blue" },
	statusline.spacer_right,
}

statusline.fileType = {
	provider = function()
		return string.upper(vim.bo.filetype)
	end,
	hl = { fg = "vibrant_green" },
	statusline.spacer_right,
}

statusline.git = {
	{
		condition = function()
			if not statusline.conditions.is_git_repo() then
				return
			end
		end,
	},
	{
		condition = statusline.conditions.is_git_repo,
		init = function(self)
			self.status_dict = vim.b.gitsigns_status_dict
			self.has_changes = self.status_dict.added ~= 0
				or self.status_dict.removed ~= 0
				or self.status_dict.changed ~= 0
		end,
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = "[ ",
		},
		{
			provider = function(self)
				return self.status_dict.head .. " "
			end,
			hl = { fg = "orange" },
		},
		{
			provider = function(self)
				local count = self.status_dict.added or 0
				return count > 0 and ("A " .. count .. " ")
			end,
			hl = { fg = "green" },
		},
		{
			provider = function(self)
				local count = self.status_dict.removed or 0
				return count > 0 and ("D " .. count .. " ")
			end,
			hl = { fg = "red" },
		},
		{
			provider = function(self)
				local count = self.status_dict.changed or 0
				return count > 0 and ("C " .. count .. " ")
			end,
			hl = { fg = "yellow2" },
		},
		{
			condition = function(self)
				return self.has_changes
			end,
			provider = "]",
		},

		statusline.spacer_right,
	},
}
statusline.ruler = {
	provider = "%l : %L : %c : %P",
	hl = function(self)
		return { fg = "green" }
	end,
	statusline.spacer_left,
}

statusline.macroRecording = {
	condition = function(self)
		return vim.fn.reg_recording() ~= ""
	end,
	update = {
		"RecordingEnter",
		"RecordingLeave",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
	{
		provider = function(self)
			return " " .. vim.fn.reg_recording() .. " "
		end,
		hl = { fg = "pink" },
	},
}

statusline.lspstatus = {
	condition = statusline.conditions.lsp_attached,
	update = { "LspAttach", "LspDetach" },
	provider = function()
		local names = {}
		for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			if server.name ~= 0 and server.name ~= "null-ls" then
				table.insert(names, "LSP")
			end
		end
		return table.concat(names, " ")
	end,
	hl = { fg = "pink" },
	statusline.spacer_left,
}

statusline.overseer = {
	condition = function()
		local ok, _ = pcall(require, "overseer")
		if ok then
			return true
		end
	end,
	init = function(self)
		self.overseer = require("overseer")
		self.tasks = self.overseer.task_list
		self.STATUS = self.overseer.constants.STATUS
	end,
	static = {
		symbols = {
			["FAILURE"] = "FAILED",
			["CANCELED"] = "CENCELED",
			["SUCCESS"] = "SUCCESS",
			["RUNNING"] = "RUNNING",
		},
		colors = {
			["FAILURE"] = "red",
			["CANCELED"] = "gray",
			["SUCCESS"] = "green",
			["RUNNING"] = "yellow",
		},
	},
	{
		condition = function(self)
			return #self.tasks.list_tasks() > 0
		end,
		{
			provider = function(self)
				local tasks_by_status =
					self.overseer.util.tbl_group_by(self.tasks.list_tasks({ unique = true }), "status")
				for _, status in ipairs(self.STATUS.values) do
					local status_tasks = tasks_by_status[status]
					if self.symbols[status] and status_tasks then
						self.color = self.colors[status]
						return "[ " .. self.symbols[status] .. " " .. tostring(#self.tasks.list_tasks()) .. " ]"
					end
				end
			end,
			hl = function(self)
				return { fg = self.color }
			end,
			on_click = {
				callback = function()
					require("neotest").run.run_last()
				end,
				name = "run_last_test",
			},
		},
	},
	statusline.spacer_left,
}

statusline.session = {
	update = { "User", pattern = "PersistedStateChange" },
	{
		condition = function(self)
			return not statusline.conditions.buffer_matches({
				filetype = self.filetypes,
			})
		end,
		statusline.spacer_left,
		{
			provider = function(self)
				if vim.g.persisting then
					return "SESSION ON"
				else
					return "SESSION OFF"
				end
			end,
			hl = { fg = "green2", bg = "bg" },
			on_click = {
				callback = function()
					vim.cmd("SessionToggle")
				end,
				name = "toggle_session",
			},
		},
		statusline.spacer_left,
	},
}
return statusline
