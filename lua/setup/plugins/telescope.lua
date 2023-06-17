local M = {}

M.init = function()
	local t = require("legendary.toolbox")
	require("legendary").keymaps({
		{
			itemgroup = "Telescope",
			description = "Fuck me Daddy",
			icon = "🔭",
			keymaps = {
				{
					"<leader>bs",
					"<cmd>Telescope current_buffer_fuzzy_find<cr>",
					desc = "Buffer Search",
				},
				{
					"<C-p>",
					t.lazy_required_fn("telescope.builtin", "find_files", {
						cwd = os.getenv("PWD"),
					}),
					description = "Find files",
				},
				{
					"<C-g>",
					function()
						require("telescope").extensions.live_grep_args.live_grep_args()
					end,
					description = "Live Grep",
				},
				{
					"<Leader>gw",
					function()
						require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
					end,
					description = "Grep word under cursor",
				},
				{
					"<leader>gw",
					function()
						require("telescope-live-grep-args.shortcuts").grep_visual_selection()
					end,
					description = "Grep Word Visual Select",
					mode = { "v" },
				},

				{
					"<leader>fn",
					t.lazy_required_fn("telescope.builtin", "find_files", {
						cwd = vim.fn.expand("~") .. "/Public/NOTES",
					}),
					description = "Find notes",
				},
				{
					"<Leader>gn",
					t.lazy_required_fn("telescope.builtin", "live_grep", {
						prompt_title = "Search Notes LG",
						cwd = vim.fn.expand("~") .. "/Public/NOTES",
						path_display = { "smart" },
					}),
					description = "Search LG Notes",
				},
			},
		},
	})
end

M.setup = function()
	local ok, telescope = pcall(require, "telescope")
	if not ok then
		return
	end

	local actions = require("telescope.actions")
	local custom_actions = require("setup.utils.telescope")

	telescope.setup({
		defaults = {
			winblend = 0,
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			color_devicons = true,
			set_env = { ["COLORTERM"] = "truecolor" },
			layout_config = {
				horizontal = {
					prompt_position = "top",
					preview_width = 0.55,
					results_width = 0.8,
				},
				vertical = {
					mirror = false,
				},
				width = 0.87,
				height = 0.80,
				preview_cutoff = 120,
			},
			prompt_prefix = " 🔎 ",
			path_display = { "smart" },
			dynamic_preview_title = true,
			selection_caret = require("setup.ui.icons").ui.Circle .. " ",
			entry_prefix = " ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			file_ignore_patterns = {
				"node_modules",
				".obsidian/*",
				"src",
				"vendors",
				".git/*",
				"^target",
				"%.aux",
				"%.toc",
				"%.pdf",
				"%.out",
				"%.log",
				".repro/*",
				".DS_Store",
				"courses/*",
				"media/*",
			},
			mappings = {
				i = {
					["<ESC>"] = actions.close,
					["<leader>"] = custom_actions.multi_selection_open,
					["<C-x>"] = custom_actions.multi_selection_open_horizontal,
					["<C-f>"] = custom_actions.multi_selection_open_vertical,
					["<C-t>"] = custom_actions.multi_selection_open_tab,
					["<C-v>"] = actions.select_vertical,
					["<C-h>"] = actions.select_horizontal,
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					["<C-w>"] = actions.send_to_qflist + actions.open_qflist,
				},
				n = { ["q"] = require("telescope.actions").close },
			},
		},
		pickers = {
			find_files = {
				find_command = {
					"fd",
					"--type",
					"f",
					"--strip-cwd-prefix",
					"--color=never",
					"--hidden",
				},
			},
		},
		extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
			},
			live_grep_args = {
				auto_quoting = true,
				default_mappings = {},
				mappings = {
					i = {
						["<C-l>"] = require("telescope-live-grep-args.actions").quote_prompt(),
						["<C-o>"] = custom_actions.insert_ignore_list,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
					},
				},
			},
		},
	})

	telescope.load_extension("live_grep_args")
	telescope.load_extension("fzf")
	telescope.load_extension("lazygit")
end

return M
