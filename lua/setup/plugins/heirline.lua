local M = {}
local gitsigns_avail, gitsigns = pcall(require, "gitsigns")
local conditions = require("heirline.conditions")
local align = { provider = "%=" }
local spacer = { provider = " " }

local filetype = {
	"^git.*",
	"fugitive",
	"dbout",
	"^aerial$",
	"^alpha$",
	"^neo--tree$",
	"^neotest--summary$",
	"^neo--tree--popup$",
	"^toggleterm$",
	"^netrw$",
	"^TelescopePrompt$",
	"^DressingInput$",
	"^lazy$",
}

local buftype = {
	"nofile",
	"prompt",
	"help",
	"terminal",
	"quickfix",
}

M.winbar = function()
	return {
		winbar = {
			{
				condition = function()
					return conditions.buffer_matches({
						buftype = buftype,
						filetype = filetype,
					})
				end,
				init = function()
					vim.opt_local.winbar = nil
				end,
			},
			----------------------------------------------------------
			-- Navic
			----------------------------------------------------------
			{
				condition = function()
					return require("nvim-navic").is_available()
				end,
				init = function(self)
					self.navic = require("nvim-navic").get_location()
				end,
				update = "CursorMoved",
				{
					condition = function(self)
						if #self.navic > 0 then
							return true
						else
							return false
						end
					end,
					{
						flexible = 3,
						{
							provider = function(self)
								return self.navic
							end,
						},
						{
							provider = "",
						},
					},
					hl = { fg = "red", italic = true },
				},
			},
			align,
			----------------------------------------------------------
			-- diagnostics
			----------------------------------------------------------
			{
				condition = conditions.has_diagnostics,
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,
				on_click = {
					callback = function()
						vim.cmd("normal gf")
					end,
					name = "heirline_diagnostics",
				},
				update = { "DiagnosticChanged", "BufEnter" },
				{
					condition = function(self)
						return self.errors > 0
					end,
					hl = { fg = "red3", bold = true },
					{
						provider = function(self)
							return vim.fn.sign_getdefined("DiagnosticSignError")[1].text .. self.errors .. " "
						end,
					},
				},
				-- Warnings
				{
					condition = function(self)
						return self.warnings > 0
					end,
					hl = { fg = "yellow", bold = true },
					{
						{
							provider = function(self)
								return vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text .. self.warnings .. " "
							end,
						},
					},
				},
				-- Hints
				{
					condition = function(self)
						return self.hints > 0
					end,
					hl = { fg = "blue", bold = true },
					{
						{
							provider = function(self)
								return " " .. vim.fn.sign_getdefined("DiagnosticSignHint")[1].text .. self.hints .. " "
							end,
						},
					},
				},
				{
					condition = function(self)
						if vim.bo.filetype ~= "lazy" then
							return self.info > 0
						end
					end,
					hl = { fg = "green", bold = true },
					{
						{
							provider = function(self)
								return " " .. vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text .. self.info .. " "
							end,
						},
					},
				},
			},
			spacer,
			----------------------------------------------------------
			-- File location
			----------------------------------------------------------
			{
				provider = function()
					return "[   " .. string.gsub(vim.fn.expand("%:p:."), "/", " / ") .. " ]"
				end,
				hl = { fg = "yellow", bold = true },
			},
			spacer,
		},
		disable_winbar_cb = function(args)
			return conditions.buffer_matches({
				buftype = buftype,
				filetype = filetype,
			}, args.buf)
		end,
	}
end

M.statusline = function()
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
				return { fg = self:mode_color(), bold = true }
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
		-- Graple recording
		-------------------------------------------------
		{
			condition = function()
				if require("grapple").exists then
					return true
				end
			end,
			provider = function()
				local key = require("grapple").key()
				if key == nil then
					return false
				end
				return "[   " .. tostring(key) .. " ]"
			end,
			update = {
				"CursorHold",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
			hl = { fg = "pink", bold = true },
		},
		spacer,
		{
			condition = function()
				return package.loaded.overseer
			end,
			init = function(self)
				self.overseer = require("overseer")
				self.neotest = require("neotest")
				self.tasks = self.overseer.task_list
				self.STATUS = self.overseer.constants.STATUS

				local index_prov = 0
				if vim.bo.filetype == "go" then
					index_prov = 1
				elseif vim.bo.filetype == "javascript" or "typescript" then
					index_prov = 2
				end

				self.ft_test =
					self.neotest.state.status_counts(self.neotest.state.adapter_ids()[index_prov], self.bufnr)
			end,
			static = {
				symbols = {
					["FAILURE"] = "FAILED",
					["CANCELED"] = "CANCELED",
					["SUCCESS"] = "PASSED",
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
				provider = function()
					return "[ "
				end,
				hl = { fg = "white", bold = true },
			},

			{
				condition = function(self)
					return #self.tasks.list_tasks() > 0
				end,
				provider = function(self)
					local success_count = 0
					local success_tasks =
						self.tasks.list_tasks({ recent_first = true, unique = true, status = self.STATUS.SUCCESS })
					if success_tasks then
						if self.ft_test then
							success_count = self.ft_test["passed"]
						else
							success_count = #success_tasks
						end
					end
					self.color = self.colors["SUCCESS"]
					return "SUCCESS " .. success_count .. " "
				end,
				hl = function(self)
					return { fg = self.color }
				end,
			},

			{
				condition = function(self)
					return #self.tasks.list_tasks() > 0
				end,
				provider = function(self)
					local failed_count = 0
					local failed_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.FAILURE })
					if failed_tasks then
						if self.ft_test then
							failed_count = self.ft_test["failed"]
						else
							failed_count = #failed_tasks
						end
					end
					self.color = self.colors["FAILURE"]
					return "FAILED " .. failed_count .. " "
				end,
				hl = function(self)
					return { fg = self.color }
				end,
			},

			{
				condition = function(self)
					return #self.tasks.list_tasks() > 0
				end,
				provider = function(self)
					local running_count = 0
					local running_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.RUNNING })
					if running_tasks then
						if self.ft_test then
							running_count = self.ft_test["running"]
						else
							running_count = #running_tasks
						end
					end
					self.color = self.colors["RUNNING"]
					return "RUNNING " .. running_count .. " "
				end,
				hl = function(self)
					return { fg = self.color }
				end,
			},

			{
				condition = function(self)
					return #self.tasks.list_tasks() > 0
				end,
				provider = function(self)
					local running_count = 0
					local cenceled_tasks = self.tasks.list_tasks({ unique = true, status = self.STATUS.CANCELED })
					if running_tasks then
						running_count = #cenceled_tasks
					end
					self.color = self.colors["CANCELED"]
					return "CANCELED " .. running_count
				end,
				hl = function(self)
					return { fg = self.color }
				end,
			},

			{
				condition = function(self)
					return #self.tasks.list_tasks() > 0
				end,
				provider = function()
					return " ]"
				end,
				hl = { fg = "white", bold = true },
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
		align,
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
				local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
				local modified = tostring((ftime > 0) and os.date("%x %X", ftime))
				if not modified then
					return ""
				else
					return "[ " .. modified .. " ]"
				end
			end,
			hl = function()
				return { fg = "yellow" }
			end,
		},
		spacer,
		-------------------------------------------------
		-- TabPage List
		{
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			require("heirline.utils").make_tablist({
				provider = function(self)
					return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
				end,
				hl = function(self)
					if self.is_active then
						return {
							bg = require("heirline.utils").get_highlight("TabLineSel").bg,
							bold = true,
							fg = "black",
						}
					else
						return { bg = "none" }
					end
				end,
			}),
		},
	})
end

M.statuscol = function()
	return {
		condition = function()
			return not conditions.buffer_matches({
				buftype = buftype,
				filetype = filetype,
			})
		end,
		static = {
			click_args = function(self, minwid, clicks, button, mods)
				local args = {
					minwid = minwid,
					clicks = clicks,
					button = button,
					mods = mods,
					mousepos = vim.fn.getmousepos(),
				}
				local sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
				if sign == " " then
					sign = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
				end
				args.sign = self.signs[sign]
				vim.api.nvim_set_current_win(args.mousepos.winid)
				vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })

				return args
			end,
			handlers = {},
		},
		init = function(self)
			self.signs = {}
			self.handlers.signs = function(args)
				return vim.schedule(vim.diagnostic.open_float)
			end
			self.handlers.line_number = function(args)
				local dap_avail, dap = pcall(require, "dap")
				if dap_avail then
					vim.schedule(dap.toggle_breakpoint)
				end
			end

			self.handlers.git_signs = function(args)
				if gitsigns_avail then
					vim.schedule(gitsigns.preview_hunk)
				end
			end

			self.handlers.fold = function(args)
				local lnum = args.mousepos.line
				if vim.fn.foldlevel(lnum) <= vim.fn.foldlevel(lnum - 1) then
					return
				end
				vim.cmd.execute("'" .. lnum .. "fold" .. (vim.fn.foldclosed(lnum) == -1 and "close" or "open") .. "'")
			end
		end,
		-----------------------------------------------------
		-- Sign
		-----------------------------------------------------
		{
			-- condition = function() return conditions.has_diagnostics() end,
			init = function(self)
				local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
					group = "*",
					lnum = vim.v.lnum,
				})

				if #signs == 0 or signs[1].signs == nil then
					self.sign = nil
					self.has_sign = false
					return
				end

				-- Filter out git signs
				signs = vim.tbl_filter(function(sign)
					return not vim.startswith(sign.group, "gitsigns")
				end, signs[1].signs)

				if #signs == 0 then
					self.sign = nil
				else
					self.sign = signs[1]
				end

				self.has_sign = self.sign ~= nil
			end,
			provider = function(self)
				if self.has_sign then
					return vim.fn.sign_getdefined(self.sign.name)[1].text
				end
				return " "
			end,

			hl = function(self)
				if self.has_sign then
					if self.sign.group == "neotest-status" then
						if self.sign.name == "neotest_running" then
							return "NeotestRunning"
						end
						if self.sign.name == "neotest_failed" then
							return "NeotestFailed"
						end
						if self.sign.name == "neotest_passed" then
							return "NeotestPassed"
						end
						return "NeotestSkipped"
					end

					-- Everything else
					local hl = self.sign.name
					return (vim.fn.hlexists(hl) ~= 0 and hl)
				end
			end,
			on_click = {
				name = "sign_click",
				callback = function(self, ...)
					if self.handlers.signs then
						self.handlers.signs(self.click_args(self, ...))
					end
				end,
			},
		},
		-----------------------------------------------------
		align,
		-----------------------------------------------------
		-- Line number
		-----------------------------------------------------
		{
			provider = function()
				if vim.v.virtnum ~= 0 then
					return ""
				end

				if vim.v.relnum == 0 then
					return vim.v.lnum
				end

				return vim.v.relnum
			end,
			on_click = {
				name = "line_number_click",
				callback = function(self, ...)
					if self.handlers.line_number then
						self.handlers.line_number(self.click_args(self, ...))
					end
				end,
			},
		},
		spacer,
		-----------------------------------------------------
		-- Gitsign
		-----------------------------------------------------
		{
			{
				condition = function()
					if not conditions.is_git_repo() or vim.v.virtnum ~= 0 then
						return
					end
				end,
			},
			{
				condition = function()
					return conditions.is_git_repo() and vim.v.virtnum == 0
				end,
				init = function(self)
					local signs = vim.fn.sign_getplaced(vim.api.nvim_get_current_buf(), {
						group = "gitsigns_vimfn_signs_",
						id = vim.v.lnum,
						lnum = vim.v.lnum,
					})

					if
						#signs == 0
						or signs[1].signs == nil
						or #signs[1].signs == 0
						or signs[1].signs[1].name == nil
					then
						self.sign = nil
					else
						self.sign = signs[1].signs[1]
					end

					self.has_sign = self.sign ~= nil
				end,
				provider = function(self)
					if self.has_sign then
						return "󰧞"
					else
						return " "
					end
				end,
				hl = function(self)
					if self.has_sign then
						return self.sign.name
					end
					return "HeirlineStatusColumn"
				end,
				on_click = {
					name = "gitsigns_click",
					callback = function(self, ...)
						if self.handlers.git_signs then
							self.handlers.git_signs(self.click_args(self, ...))
						end
					end,
				},
			},
		},
		spacer,
		-----------------------------------------------------
		-- Fold
		-----------------------------------------------------
		{
			condition = function()
				return vim.v.virtnum == 0
			end,
			init = function(self)
				self.lnum = vim.v.lnum
				self.folded = vim.fn.foldlevel(self.lnum) > vim.fn.foldlevel(self.lnum - 1)
			end,
			{
				condition = function(self)
					return self.folded
				end,
				{
					provider = function(self)
						if vim.fn.foldclosed(self.lnum) == -1 then
							return ""
						end
					end,
				},
				{
					provider = function(self)
						if vim.fn.foldclosed(self.lnum) ~= -1 then
							return ""
						end
					end,
				},
			},
			hl = { fg = "comment" },
			{
				condition = function(self)
					return not self.folded
				end,
				provider = " ",
			},
			on_click = {
				name = "fold_click",
				callback = function(self, ...)
					if self.handlers.fold then
						self.handlers.fold(self.click_args(self, ...))
					end
				end,
			},
		},
		spacer,
	}
end

return M
