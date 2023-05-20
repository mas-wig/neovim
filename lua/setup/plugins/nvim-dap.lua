local M = {}

M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "Debug",
			description = "Debugging functionality...",
			icon = "",
			keymaps = {
				{
					"<leader>dR",
					function()
						require("dap").run_to_cursor()
					end,
					desc = "Run to Cursor",
				},
				{
					"<leader>dE",
					function()
						require("dapui").eval(vim.fn.input("[Expression] > "))
					end,
					desc = "Evaluate Input",
				},
				{
					"<leader>dC",
					function()
						require("dap").set_breakpoint(vim.fn.input("[Condition] > "))
					end,
					desc = "Conditional Breakpoint",
				},
				{
					"<leader>dU",
					function()
						require("dapui").toggle()
					end,
					desc = "Toggle UI",
				},
				{
					"<leader>db",
					function()
						require("dap").step_back()
					end,
					desc = "Step Back",
				},
				{
					"<leader>dc",
					function()
						require("dap").continue()
					end,
					desc = "Continue",
				},
				{
					"<leader>dd",
					function()
						require("dap").disconnect()
					end,
					desc = "Disconnect",
				},
				{
					"<leader>de",
					function()
						require("dapui").eval()
					end,
					mode = { "n", "v" },
					desc = "Evaluate",
				},
				{
					"<leader>dg",
					function()
						require("dap").session()
					end,
					desc = "Get Session",
				},
				{
					"<leader>dh",
					function()
						require("dap.ui.widgets").hover()
					end,
					desc = "Hover Variables",
				},
				{
					"<leader>dS",
					function()
						require("dap.ui.widgets").scopes()
					end,
					desc = "Scopes",
				},
				{
					"<leader>di",
					function()
						require("dap").step_into()
					end,
					desc = "Step Into",
				},
				{
					"<leader>do",
					function()
						require("dap").step_over()
					end,
					desc = "Step Over",
				},
				{
					"<leader>dp",
					function()
						require("dap").pause.toggle()
					end,
					desc = "Pause",
				},
				{
					"<leader>dq",
					function()
						require("dap").close()
					end,
					desc = "Quit",
				},
				{
					"<leader>dr",
					function()
						require("dap").repl.toggle()
					end,
					desc = "Toggle REPL",
				},
				{
					"<leader>ds",
					function()
						require("dap").continue()
					end,
					desc = "Start",
				},
				{
					"<leader>dt",
					function()
						require("dap").toggle_breakpoint()
					end,
					desc = "Toggle Breakpoint",
				},
				{
					"<leader>dx",
					function()
						require("dap").terminate()
					end,
					desc = "Terminate",
				},
				{
					"<leader>du",
					function()
						require("dap").step_out()
					end,
					desc = "Step Out",
				},
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
