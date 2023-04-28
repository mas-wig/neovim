local M = {}

M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "Debug",
			description = "Debugging functionality...",
			icon = "",
			keymaps = {
				{ "<leader>dR", "<cmd>lua require'dap'.run_to_cursor()<cr>", description = "Run to Cursor" },
				{
					"<leader>dE",
					"<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>",
					description = "Evaluate Input",
				},
				{
					"<leader>dC",
					"<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
					description = "Conditional Breakpoint",
				},
				{ "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>", description = "Toggle UI" },
				{ "<leader>db", "<cmd>lua require'dap'.step_back()<cr>", description = "Step Back" },
				{ "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", description = "Continue" },
				{ "<leader>dd", "<cmd>lua require'dap'.disconnect()<cr>", description = "Disconnect" },
				{ "<leader>de", "<cmd>lua require'dapui'.eval()<cr>", description = "Evaluate" },
				{ "<leader>dg", "<cmd>lua require'dap'.session()<cr>", description = "Get Session" },
				{ "<leader>dh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", description = "Hover Variables" },
				{ "<leader>dS", "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", description = "Scopes" },
				{ "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", description = "Step Into" },
				{ "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", description = "Step Over" },
				{ "<leader>dp", "<cmd>lua require'dap'.pause.toggle()<cr>", description = "Pause" },
				{ "<leader>dq", "<cmd>lua require'dap'.close()<cr>", description = "Quit" },
				{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", description = "Toggle Repl" },
				{ "<leader>ds", "<cmd>lua require'dap'.continue()<cr>", description = "Start" },
				{
					"<leader>dt",
					"<cmd>lua require'dap'.toggle_breakpoint()<cr>",
					description = "Toggle Breakpoint",
				},
				{ "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", description = "Terminate" },
				{ "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", description = "Step Out" },
				-- Floating dap windows --
				{

					"<leader>dft",
					function()
						require("dapui").float_element("scopes", { width = 100, height = 20, enter = true })
					end,
					description = "Scope Float",
				},
				{

					"<leader>dfr",
					function()
						require("dapui").float_element("repl", { width = 100, height = 20, enter = true })
					end,
					description = "Repl Float",
				},
				{

					"<leader>dfc",
					function()
						require("dapui").float_element("console", { width = 100, height = 20, enter = true })
					end,
					description = "Console Float",
				},
				{

					"<leader>dfb",
					function()
						require("dapui").float_element("breakpoints", { width = 100, height = 20, enter = true })
					end,
					description = "Breakpoint Float",
				},
				{

					"<leader>dfs",
					function()
						require("dapui").float_element("stacks", { width = 100, height = 20, enter = true })
					end,
					description = "Stacks Float",
				},
				{

					"<leader>dfw",
					function()
						require("dapui").float_element("watches", { width = 100, height = 20, enter = true })
					end,
					description = "Watches Float",
				},
			},
		},
	})
end

M.setup = function()
	local dap = require("dap")
	local function virtual_text_setup()
		local ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
		if not ok then
			return
		end

		return virtual_text.setup()
	end

	---Show custom virtual text when debugging
	---@return nil
	local function signs_setup()
		vim.fn.sign_define("DapBreakpoint", {
			text = " ",
			texthl = "DebugBreakpoint",
			linehl = "",
			numhl = "DebugBreakpoint",
		})
		vim.fn.sign_define("DapStopped", {
			text = " ",
			texthl = "DebugHighlight",
			linehl = "",
			numhl = "DebugHighlight",
		})
	end

	local function delve(dap)
		dap.adapters.delve = function(callback, _)
			callback({
				type = "server",
				host = "127.0.0.1",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			})
		end

		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test", -- configuration for debugging test files
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			-- works with go.mod packages and sub packages
			{
				type = "delve",
				name = "Debug test (go.mod)",
				request = "launch",
				mode = "test",
				program = "./${relativeFileDirname}",
			},
		}
	end
	local function ui_setup(dap)
		local ok, dapui = pcall(require, "dapui")
		if not ok then
			return
		end

		dapui.setup({
			layouts = {
				{
					elements = {
						"scopes",
						"breakpoints",
						"stacks",
					},
					size = 35,
					position = "left",
				},
				{
					elements = {
						"repl",
					},
					size = 0.30,
					position = "bottom",
				},
			},
		})
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end

	dap.set_log_level("TRACE")

	virtual_text_setup()
	signs_setup()
	delve(dap)
	ui_setup(dap)
end

return M
