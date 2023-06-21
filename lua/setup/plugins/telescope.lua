local M = {}

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
					["<C-space>"] = custom_actions.multi_selection_open,
					["<A-h>"] = custom_actions.multi_selection_open_horizontal,
					["<A-v>"] = custom_actions.multi_selection_open_vertical,
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
end

M.keys = {
	{
		"<C-p>",
		function()
			require("telescope.builtin").find_files({ cwd = os.getenv("PWD") })
		end,
		desc = "Telescope Find File",
	},
	{
		"<C-g>g",
		function()
			require("telescope").extensions.live_grep_args.live_grep_args()
		end,
		desc = "Live Grep",
	},
	{
		"<C-g>w",
		function()
			require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
		end,
		desc = "Grep word under cursor",
	},
	{
		"<C-g>s",
		function()
			require("telescope-live-grep-args.shortcuts").grep_visual_selection()
		end,
		desc = "Grep Word Visual Select",
		mode = { "v" },
	},
	{
		"<leader>fB",
		function()
			require("telescope.builtin").buffers()
		end,
		desc = "Telescope List Buffers",
	},
	{
		"<leader>fo",
		function()
			require("telescope.builtin").oldfiles()
		end,
		desc = "Telescope Open Recent Files",
	},
	{
		"<leader>fc",
		function()
			require("telescope.builtin").commands()
		end,
		desc = "Telescope List Commands",
	},
	{
		"<leader>fp",
		function()
			require("telescope.builtin").tags()
		end,
		desc = "Telescope List Tags",
	},
	{
		"<leader>fh",
		function()
			require("telescope.builtin").command_history()
		end,
		desc = "Telescope Command History",
	},
	{
		"<leader>fs",
		function()
			require("telescope.builtin").search_history()
		end,
		desc = "Telescope Search History",
	},
	{
		"<leader>fh",
		function()
			require("telescope.builtin").help_tags()
		end,
		desc = "Telescope Help Tags",
	},
	{
		"<leader>fm",
		function()
			require("telescope.builtin").man_pages()
		end,
		desc = "Telescope Man Pages",
	},
	{
		"<leader>fM",
		function()
			require("telescope.builtin").marks()
		end,
		desc = "Telescope List Marks",
	},
	{
		"<leader>fs",
		function()
			require("telescope.builtin").colorscheme()
		end,
		desc = "Telescope Colorscheme",
	},
	{
		"<leader>fq",
		function()
			require("telescope.builtin").quickfix()
		end,
		desc = "Telescope Quickfix List",
	},
	{
		"<leader>fQ",
		function()
			require("telescope.builtin").quickfix_history()
		end,
		desc = "Telescope Quickfix History",
	},
	{
		"<leader>fl",
		function()
			require("telescope.builtin").loclist()
		end,
		desc = "Telescope Location List",
	},
	{
		"<leader>fj",
		function()
			require("telescope.builtin").jumplist()
		end,
		desc = "Telescope Jump List",
	},
	{
		"<leader>fv",
		function()
			require("telescope.builtin").vim_options()
		end,
		desc = "Telescope Vim Options",
	},
	{
		"<leader>fr",
		function()
			require("telescope.builtin").registers()
		end,
		desc = "Telescope List Registers",
	},
	{
		"<leader>fa",
		function()
			require("telescope.builtin").autocommands()
		end,
		desc = "Telescope List Autocommands",
	},
	{
		"<leader>fs",
		function()
			require("telescope.builtin").spell_suggest()
		end,
		desc = "Telescope Spell Suggestions",
	},
	{
		"<leader>fk",
		function()
			require("telescope.builtin").keymaps()
		end,
		desc = "Telescope Keymaps",
	},
	{
		"<leader>fF",
		function()
			require("telescope.builtin").filetypes()
		end,
		desc = "Telescope Filetypes",
	},
	{
		"<leader>fh",
		function()
			require("telescope.builtin").highlights()
		end,
		desc = "Telescope Highlights",
	},
	{
		"<leader>fcf",
		function()
			require("telescope.builtin").current_buffer_fuzzy_find()
		end,
		desc = "Telescope Fuzzy Find in Current Buffer",
	},
	{
		"<leader>fct",
		function()
			require("telescope.builtin").current_buffer_tags()
		end,
		desc = "Telescope Tags in Current Buffer",
	},
	{
		"<leader>fr",
		function()
			require("telescope.builtin").resume()
		end,
		desc = "Telescope Resume Last Picker",
	},
	{
		"<leader>fg",
		function()
			require("telescope.builtin").git_commits()
		end,
		desc = "Telescope Git Commits",
	},
	{
		"<leader>fb",
		function()
			require("telescope.builtin").git_bcommits()
		end,
		desc = "Telescope Git Buffer Commits",
	},
	{
		"<leader>fc",
		function()
			require("telescope.builtin").git_branches()
		end,
		desc = "Telescope Git Branches",
	},
	{
		"<leader>fs",
		function()
			require("telescope.builtin").git_status()
		end,
		desc = "Telescope Git Status",
	},
	{
		"<leader>fe",
		function()
			require("telescope.builtin").git_stash()
		end,
		desc = "Telescope Git Stash",
	},
}

return M
