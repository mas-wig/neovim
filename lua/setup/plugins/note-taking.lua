local M = {}
M.template = {
	template = "---\n"
		.. 'id: "{{filename}}"\n'
		.. 'date: "{{date}}"\n'
		.. "alias:\n"
		.. '  - "{{filename}}"\n'
		.. "tags:\n"
		.. '  - "#{{current_folder}}"\n'
		.. '  - "#{{target_dir}}/{{current_date}}"\n'
		.. "---\n"
		.. "\n",
	placeholders = {
		before = {
			date = function()
				return os.date("%A, %B %d, %Y") -- Wednesday, March 1, 2023
			end,
		},
		after = {
			current_folder = function()
				local location = vim.fn.expand("%:p:h")
				if location == "." then
					location = "root"
				end
				return string.gsub(location, tostring(vim.fn.getcwd()) .. "/", "")
			end,
			target_dir = function()
				local location = vim.fn.expand("%:p:h")
				if tostring(location) == "." then
					location = "root"
				end
				return string.match(location, ".+/([^/]+)")
			end,
			filename = function()
				return vim.fn.expand("%:t:r")
			end,
			current_date = function()
				return os.date("%d%m%Y")
			end,
		},
	},
}

M.cmd_mkdnflow = {
	"MkdnEnter",
	"MkdnNextLink",
	"MkdnPrevLink",
	"MkdnNextHeading",
	"MkdnPrevHeading",
	"MkdnGoBack",
	"MkdnGoForward",
	"MkdnCreateLink",
	"MkdnCreateLinkFromClipboard",
	"MkdnFollowLink",
	"MkdnDestroyLink",
	"MkdnTagSpan",
	"MkdnMoveSource",
	"MkdnYankAnchorLink",
	"MkdnYankFileAnchorLink",
	"MkdnIncreaseHeading",
	"MkdnDecreaseHeading",
	"MkdnToggleToDo",
	"MkdnUpdateNumbering",
	"MkdnNewListItem",
	"MkdnNewListItemBelowInsert",
	"MkdnNewListItemAboveInsert",
	"MkdnExtendList",
	"MkdnTable",
	"MkdnTableFormat",
	"MkdnTableNextCell",
	"MkdnTablePrevCell",
	"MkdnTableNewRowBelow",
	"MkdnTableNewRowAbove",
	"MkdnTableNewColAfter",
	"MkdnTableNewColBefore",
	"MkdnTab",
	"MkdnSTab",
	"MkdnFoldSection",
	"MkdnUnfoldSection",
	"Mkdnflow",
}

M.mkdnflow_setup = function()
	return require("mkdnflow").setup({
		modules = {
			bib = true,
			buffers = true,
			conceal = true,
			cursor = true,
			folds = true,
			links = true,
			lists = true,
			maps = true,
			paths = true,
			tables = true,
			yaml = false,
		},
		filetypes = { md = true, rmd = true, markdown = true },
		create_dirs = true,
		perspective = {
			priority = "current",
			fallback = "current",
			root_tell = false,
			nvim_wd_heel = false,
			update = false,
		},
		wrap = false,
		default_path = nil,
		bib = { find_in_root = false },
		silent = false,
		links = {
			style = "markdown",
			name_is_source = false,
			conceal = false,
			context = 0,
			implicit_extension = nil,
			transform_implicit = false,
			transform_explicit = function()
				local suffix = ""
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end

				if string.len(suffix) > 4 then
					string.lower(suffix:gsub(" ", "_"))
				end
				return tostring(os.date("%d%m%Y")) .. "_" .. suffix
			end,
		},
		new_file_template = {
			use_template = true,
			placeholders = {
				before = M.template.placeholders.before,
				after = M.template.placeholders.after,
			},
			template = M.template.template,
		},
		to_do = {
			symbols = { " ", "-", "v" },
			update_parents = true,
			not_started = " ",
			in_progress = "-",
			complete = "v",
		},
		tables = {
			trim_whitespace = true,
			format_on_move = true,
			auto_extend_rows = true,
			auto_extend_cols = true,
		},
		yaml = { bib = { override = false } },
		mappings = {
			MkdnEnter = { { "n", "v" }, "<leader>nn", { desc = "Create New Note" } },
			MkdnTab = { "n", "<leader>nt", { desc = "Tab" } },
			MkdnSTab = { "n", "<leader>nT", { desc = "Shift + Tab" } },
			MkdnNextLink = { "n", "<leader>nL", { desc = "Navigate to Next Link" } },
			MkdnPrevLink = { "n", "<leader>nP", { desc = "Navigate to Previous Link" } },
			MkdnNextHeading = { "n", "<leader>nh", { desc = "Navigate to Next Heading" } },
			MkdnPrevHeading = { "n", "<leader>ng", { desc = "Navigate to Previous Heading" } },
			MkdnGoBack = { "n", "<leader>nb", { desc = "Go Back" } },
			MkdnGoForward = { "n", "<leader>nf", { desc = "Go Forward" } },
			MkdnCreateLink = { { "n", "v" }, "<leader>ncl", { desc = "Create Link" } },
			MkdnCreateLinkFromClipboard = { "n", "<leader>ncL", { desc = "Create Link from Clipboard" } },
			MkdnFollowLink = { { "n", "v" }, "<leader>nl", { desc = "Follow Link" } },
			MkdnDestroyLink = { "n", "<leader>nx", { desc = "Destroy Link" } },
			MkdnTagSpan = { "n", "<leader>nt", { desc = "Tag Span" } },
			MkdnMoveSource = { "n", "<leader>nm", { desc = "Move Source" } },
			MkdnYankAnchorLink = { "n", "<leader>ny", { desc = "Yank Anchor Link" } },
			MkdnYankFileAnchorLink = { "n", "<leader>nY", { desc = "Yank File Anchor Link" } },
			MkdnIncreaseHeading = { "n", "<leader>ni", { desc = "Increase Heading Level" } },
			MkdnDecreaseHeading = { "n", "<leader>nd", { desc = "Decrease Heading Level" } },
			MkdnToggleToDo = { { "n", "v" }, "<leader>Nt", { desc = "Toggle Todo" } },
			MkdnNewListItem = { "n", "<leader>ni", { desc = "New List Item" } },
			MkdnNewListItemBelowInsert = { "n", "<leader>nbli", { desc = "New List Item Below and Insert" } },
			MkdnNewListItemAboveInsert = { "n", "<leader>nai", { desc = "New List Item Above and Insert" } },
			MkdnExtendList = { "n", "<leader>nel", { desc = "Extend List" } },
			MkdnUpdateNumbering = { "n", "<leader>nu", { desc = "Update Numbering" } },
			MkdnTableNextCell = { "n", "<leader>ntn", { desc = "Table Next Cell" } },
			MkdnTablePrevCell = { "n", "<leader>ntp", { desc = "Table Previous Cell" } },
			MkdnTableNextRow = false,
			MkdnTablePrevRow = { "n", "<leader>ntpr", { desc = "Table Previous Row" } },
			MkdnTableNewRowBelow = { "n", "<leader>ntb", { desc = "Table New Row Below" } },
			MkdnTableNewRowAbove = { "n", "<leader>nta", { desc = "Table New Row Above" } },
			MkdnTableNewColAfter = { "n", "<leader>ntca", { desc = "Table New Column After" } },
			MkdnTableNewColBefore = { "n", "<leader>ntcb", { desc = "Table New Column Before" } },
			MkdnFoldSection = { "n", "<leader>nf", { desc = "Fold Section" } },
			MkdnUnfoldSection = { "n", "<leader>nF", { desc = "Unfold Section" } },
			Mkdnflow = { "n", "<leader>nN", { desc = "Flow" } },
		},
	})
end

M.mkdn_expl = {
	{
		"<A-n>",
		function()
			require("neo-tree.command").execute({
				toggle = true,
				dir = vim.fn.expand("~") .. "/Public/NOTES",
				position = "left",
				source = "filesystem",
			})
		end,
		desc = "Explorer NeoTree (root dir)",
	},
}

return M
