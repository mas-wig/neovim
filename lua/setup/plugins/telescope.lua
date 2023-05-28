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
						prompt_title = false,
						results_title = false,
						dynamic_preview_title = false,
						hidden = true,
					}),
					description = "Find files",
				},
				{
					"<C-g>",
					t.lazy_required_fn(
						"telescope.builtin",
						"live_grep",
						{ prompt_title = "Open Files", path_display = { "shorten" }, grep_open_files = true }
					),
					description = "Find in open files",
				},
				{
					"<Leader>gb",
					t.lazy_required_fn(
						"telescope.builtin",
						"live_grep",
						{ prompt_title = "Search CWD", path_display = { "smart" } }
					),
					description = "Search CWD",
				},
				{
					"<leader>bl",
					t.lazy_required_fn(
						"telescope.builtin",
						"buffers",
						{ prompt_title = "Buffer List", path_display = { "smart" } }
					),
					description = "List buffers",
				},
			},
		},
	})
end

M.setup = function()
	local ok, telescope = pcall(require, "telescope")
	local actions = require("telescope.actions")
	local actions_layout = require("telescope.actions.layout")

	if not ok then
		return
	end

	local config = {
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
			selection_caret = "🎲 ",
			entry_prefix = " ",
			initial_mode = "insert",
			selection_strategy = "reset",
			sorting_strategy = "ascending",
			file_ignore_patterns = {
				"node_modules",
				-- "assets",
				".git/*",
				"^target",
				"%.aux",
				"%.toc",
				"%.pdf",
				"%.out",
				"%.log",
				".repro/*",
				".DS_Store",
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--hidden",
				"--column",
				"--smart-case",
				"--trim",
			},
			mappings = {
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
				case_mode = "smart_case",
			},
			persisted = {
				prompt_title = false,
				results_title = false,
				layout_config = { width = 0.55, height = 0.55 },
			},
		},
	}

	telescope.setup(config)
	telescope.load_extension("fzf")
	telescope.load_extension("lazygit")
end

return M
