local M = {}
M.setup = function()
	require("overseer").setup({
		task_win = {
			padding = 2,
			border = "rounded",
			win_opts = {
				winblend = 0,
			},
		},
		component_aliases = {
			default_neotest = {
				"unique",
				"on_output_summarize",
				"on_exit_set_status",
				"on_complete_dispose",
				{ "on_complete_notify", system = "unfocused", on_change = true },
			},
		},
		templates = {},
	})
end

M.keys = {
	{ "<Leader>ok", "<cmd>OverseerRestartLast<cr>", desc = "Run the last Overseer task" },
	{ "<leader>oC", "<cmd>OverseerClose<cr>", desc = "Overseer Close" },
	{ "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer Task Action" },
	{ "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
	{ "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Overseer Run Cmd" },
	{ "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Overseer Delete Bundle" },
	{ "<leader>ol", "<cmd>OverseerLoadBundle<cr>", desc = "Overseer Load Bundle" },
	{ "<leader>oo", "<cmd>OverseerOpen!<cr>", desc = "Overseer Open" },
	{ "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Overseer Quick Action" },
	{ "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer Run" },
	{ "<leader>os", "<cmd>OverseerSaveBundle<cr>", desc = "Overseer Save Bundle" },
	{ "<leader>ot", "<cmd>OverseerToggle!<cr>", desc = "Overseer Toggle" },
}

M.cmd = {
	"OverseerOpen",
	"OverseerClose",
	"OverseerToggle",
	"OverseerSaveBundle",
	"OverseerLoadBundle",
	"OverseerDeleteBundle",
	"OverseerRunCmd",
	"OverseerRun",
	"OverseerInfo",
	"OverseerBuild",
	"OverseerQuickAction",
	"OverseerTaskAction",
	"OverseerClearCache",
}

return M
