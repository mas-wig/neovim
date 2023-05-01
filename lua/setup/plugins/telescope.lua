local M = {}

M.init = function()
	local t = require("legendary.toolbox")
	require("legendary").keymaps({
		{
			itemgroup = "Telescope",
			description = "Fuck me Daddy",
			icon = "🔭",
			keymaps = {
				{ "<leader>fb", "<cmd>Telescope file_browser<cr>", description = "File browser" },
				{ "<leader>mf", "<cmd>Telescope media_files<cr>", description = "Media File" },
				{
					"<leader>bs",
					"<cmd>Telescope current_buffer_fuzzy_find<cr>",
					desc = "Buffer Search",
				},
				{
					"<leader>ff",
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
			media_files = {
				filetypes = { "png", "svg", "gift", "webp", "jpg", "jpeg" },
				find_cmd = "rg",
			},
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
			file_browser = {
				multi_icon = " 👉 ",
				prompt_title = false,
				results_title = false,
				layout_config = {
					horizontal = {
						prompt_position = "bottom",
						results_width = 0.6,
					},
					vertical = {
						mirror = false,
					},
					width = 0.93,
					height = 0.84,
				},
				-- theme             = "ivy",
				hide_parent_dir = true,
				hijack_netrw = false,
				previewer = false,
				prompt_path = true,
				hidden = true,
				respect_gitignore = false,
				grouped = true,
				border = true,
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["?"] = actions_layout.toggle_preview,
					},
				},
			},
		},
	}

	telescope.setup(config)
	telescope.load_extension("fzf")
	telescope.load_extension("file_browser")
	telescope.load_extension("media_files")
	telescope.load_extension("persisted")
end

return M
