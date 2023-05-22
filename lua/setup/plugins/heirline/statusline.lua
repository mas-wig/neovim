local conditions = require("heirline.conditions")
local align = { provider = "%=" }
local spacer = { provider = " " }

return require("heirline.utils").insert({
	static = {
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
	},
	hl = { bg = "none" },
	spacer,
	-------------------------------------------------
	-- Vim Mode
	-------------------------------------------------
	{
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
				n = "N",
				no = "N?",
				nov = "N?",
				noV = "N?",
				["no\22"] = "N?",
				niI = "Ni",
				niR = "Nr",
				niV = "Nv",
				nt = "Nt",
				v = "V",
				vs = "Vs",
				V = "V-B",
				Vs = "Vs",
				["\22"] = "^V",
				["\22s"] = "^V",
				s = "S",
				S = "S_",
				["\19"] = "^S",
				i = "I",
				ic = "Ic",
				ix = "Ix",
				R = "R",
				Rc = "Rc",
				Rx = "Rx",
				Rv = "Rv",
				Rvc = "Rv",
				Rvx = "Rv",
				c = "C",
				cv = "Ex",
				r = "...",
				rm = "M",
				["r?"] = "?",
				["!"] = "!",
				t = "T",
			},
		},
		provider = function(self)
			--	return " " .. self.mode_names[self.mode]
			return " %2(" .. self.mode_names[self.mode] .. "%)"
		end,
		hl = function(self)
			return { fg = self:mode_color(), bg = "bg", bold = true }
		end,
		update = {
			"ModeChanged",
		},
	},
	spacer,

	-------------------------------------------------
	-- Git
	-------------------------------------------------
	{
		{
			condition = function()
				if not conditions.is_git_repo() then
					return
				end
			end,
		},
		{
			condition = conditions.is_git_repo,
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
				hl = { bold = true },
			},
			{
				provider = function(self)
					if not self.status_dict.head then
						return
					end
					return string.upper(self.status_dict.head) .. " "
				end,
				hl = { bold = true, fg = "orange" },
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and (require("setup.ui.icons").git.added .. count .. " ")
				end,
				hl = { fg = "green", bold = true },
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and (require("setup.ui.icons").git.deleted .. count .. " ")
				end,
				hl = { fg = "red", bold = true },
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and (require("setup.ui.icons").git.modified .. count .. " ")
				end,
				hl = { fg = "yellow2", bold = true },
			},
			{
				condition = function(self)
					return self.has_changes
				end,
				provider = "]",
				hl = { bold = true },
			},
		},
	},
	spacer,

	-------------------------------------------------
	-- Macro recording
	-------------------------------------------------
	{
		condition = function()
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
			provider = function()
				return vim.fn.reg_recording()
			end,
			hl = { fg = "pink" },
		},
	},
	spacer,
	-------------------------------------------------
	-- Overseer

	--{
	-- 	condition = function()
	-- 		local ok, _ = pcall(require, "overseer")
	-- 		if ok then
	-- 			return true
	-- 		end
	-- 	end,
	-- 	init = function(self)
	-- 		self.overseer = require("overseer")
	-- 		self.neotest = require("neotest")
	-- 		self.go_test = self.neotest.state.status_counts(self.neotest.state.adapter_ids()[1], self.bufnr)
	-- 		self.tasks = self.overseer.task_list
	-- 		self.STATUS = self.overseer.constants.STATUS
	-- 	end,
	-- 	static = {
	-- 		symbols = {
	-- 			["FAILURE"] = "FAILED",
	-- 			["CANCELED"] = "CANCELED",
	-- 			["SUCCESS"] = "PASSED",
	-- 			["RUNNING"] = "RUNNING",
	-- 		},
	-- 		colors = {
	-- 			["FAILURE"] = "red",
	-- 			["CANCELED"] = "gray",
	-- 			["SUCCESS"] = "green",
	-- 			["RUNNING"] = "yellow",
	-- 		},
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function()
	-- 			return "[ "
	-- 		end,
	-- 		hl = { fg = "white", bold = true },
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function(self)
	-- 			local success_count = 0
	-- 			local success_tasks =
	-- 				self.tasks.list_tasks({ recent_first = true, unique = true, status = self.STATUS.SUCCESS })
	-- 			if success_tasks then
	-- 				if self.go_test then
	-- 					success_count = self.go_test["passed"]
	-- 				else
	-- 					success_count = #success_tasks
	-- 				end
	-- 			end
	-- 			self.color = self.colors["SUCCESS"]
	-- 			return "SUCCESS " .. success_count .. " "
	-- 		end,
	-- 		hl = function(self)
	-- 			return { fg = self.color }
	-- 		end,
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function(self)
	-- 			local failed_count = 0
	-- 			local failed_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.FAILURE })
	-- 			if failed_tasks then
	-- 				if self.go_test then
	-- 					failed_count = self.go_test["failed"]
	-- 				else
	-- 					failed_count = #failed_tasks
	-- 				end
	-- 			end
	-- 			self.color = self.colors["FAILURE"]
	-- 			return "FAILED " .. failed_count .. " "
	-- 		end,
	-- 		hl = function(self)
	-- 			return { fg = self.color }
	-- 		end,
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function(self)
	-- 			local running_count = 0
	-- 			local running_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.RUNNING })
	-- 			if running_tasks then
	-- 				if self.go_test then
	-- 					running_count = self.go_test["running"]
	-- 				else
	-- 					running_count = #running_tasks
	-- 				end
	-- 			end
	-- 			self.color = self.colors["RUNNING"]
	-- 			return "RUNNING " .. running_count .. " "
	-- 		end,
	-- 		hl = function(self)
	-- 			return { fg = self.color }
	-- 		end,
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function(self)
	-- 			local running_count = 0
	-- 			local cenceled_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.CANCELED })
	-- 			if running_tasks then
	-- 				running_count = #cenceled_tasks
	-- 			end
	-- 			self.color = self.colors["CANCELED"]
	-- 			return "CANCELED " .. running_count
	-- 		end,
	-- 		hl = function(self)
	-- 			return { fg = self.color }
	-- 		end,
	-- 	},
	--
	-- 	{
	-- 		condition = function(self)
	-- 			return #self.tasks.list_tasks() > 0
	-- 		end,
	-- 		provider = function()
	-- 			return " ]"
	-- 		end,
	-- 		hl = { fg = "white", bold = true },
	-- 	},
	-- },
	-------------------------------------------------
	align,
	-------------------------------------------------
	--Lazy
	{
		condition = function(self)
			return not conditions.buffer_matches({
				filetype = self.filetypes,
			}) and require("lazy.status").has_updates()
		end,
		provider = function()
			return "Lzy " .. require("lazy.status").updates()
		end,
		on_click = {
			callback = function()
				require("lazy").update()
			end,
			name = "update_plugins",
		},
		hl = { fg = "blue" },
	},
	spacer,
	-------------------------------------------------
	-- lsp status
	{
		condition = require("heirline.conditions").lsp_attached,
		update = {
			"LspDetach",
			"LspAttach",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
		provider = function()
			local names = {}
			for _, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
				if server.name ~= 0 and server.name ~= "null-ls" then
					table.insert(names, "[ LSP ON ]")
				end
			end
			return table.concat(names, " ")
		end,
		hl = { fg = "pink" },
	},
	spacer,
	-------------------------------------------------
	-- Ruller
	{
		provider = function()
			return "[ %l : %c : %L : %P ]"
		end,
		hl = function()
			return { fg = "green" }
		end,
	},
	spacer,
	-------------------------------------------------
	-- Last file modified
	{
		provider = function()
			if vim.o.filetype == "alpha" then
				return ""
			else
				local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
				return "[ " .. tostring((ftime > 0) and os.date("%x %X", ftime)) .. " ]"
			end
		end,
		hl = function()
			return { fg = "yellow" }
		end,
	},
	spacer,
	-------------------------------------------------
})
