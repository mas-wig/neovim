local M = {}

M.server = function()
	return {
		golang = {
			adapters = {
				type = "server",
				port = "${port}",
				executable = {
					command = require("mason-registry").get_package("delve"):get_install_path() .. "/dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			},

			configurations = {
				{
					type = "go",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug test", -- configuration for debugging test files
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				-- works with go.mod packages and sub packages
				{
					type = "go",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			},
		},
	}
end

M.keys = {
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

	-- floating window
	{
		"<leader>dfs",
		function()
			require("dapui").float_element(
				"scopes",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Scope Float",
	},
	{

		"<leader>dfr",
		function()
			require("dapui").float_element(
				"repl",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Repl Float",
	},
	{

		"<leader>dfc",
		function()
			require("dapui").float_element(
				"console",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Console Float",
	},
	{

		"<leader>dfb",
		function()
			require("dapui").float_element(
				"breakpoints",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Breakpoint Float",
	},
	{

		"<leader>dfS",
		function()
			require("dapui").float_element(
				"stacks",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Stacks Float",
	},
	{

		"<leader>dfw",
		function()
			require("dapui").float_element(
				"watches",
				{ width = vim.o.columns, height = vim.o.lines, enter = true, position = "center" }
			)
		end,
		desc = "Watches Float",
	},
}

M.setup = function()
	local dap, dapui = require("dap"), require("dapui")
	require("nvim-dap-virtual-text").setup({
		commented = true,
		enabled_commands = true,
		all_frames = true,
	})
	dapui.setup({
		layouts = {
			{
				elements = {
					{
						id = "scopes",
						size = 0.25,
					},
					{
						id = "breakpoints",
						size = 0.25,
					},
					{
						id = "stacks",
						size = 0.25,
					},
					{
						id = "watches",
						size = 0.25,
					},
				},
				position = "right",
				size = 55,
			},
			{
				elements = {
					{
						id = "repl",
						size = 0.5,
					},
					{
						id = "console",
						size = 0.5,
					},
				},
				position = "bottom",
				size = 8,
			},
		},
	})

	vim.fn.sign_define("DapBreakpoint", { text = "🟥" })
	vim.fn.sign_define("DapStopped", { text = "🟨" })
	vim.fn.sign_define("DapBreakpointRejected", { text = "🟩" })

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	local dap_configs = {
		go = M.server().golang,
	}

	for dap_name, dap_options in pairs(dap_configs) do
		dap.adapters[dap_name] = dap_options.adapters
		dap.configurations[dap_name] = dap_options.configurations
	end
end

return M
