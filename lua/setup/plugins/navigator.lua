return require("navigator").setup({
	border = "rounded",
	ts_fold = false,
	default_mapping = false,
	transparency = 100,
	lsp_signature_help = false,
	lsp = {
		disable_lsp = "all",
		format_on_save = false,
		document_highlight = false,
		diagnostic = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 30,
				underline = true,
				update_in_insert = true,
				prefix = "  ",
			},
			severity_sort = true,
		},
		diagnostic_virtual_text = true,
		diagnostic_scrollbar_sign = true,
		diagnostic_update_in_insert = false,
		disply_diagnostic_qf = false,
	},
	icons = {
		icons = true,
		diagnostic_err = require("setup.ui.icons").diagnostics.Error,
		diagnostic_warn = require("setup.ui.icons").diagnostics.Warn,
		diagnostic_info = require("setup.ui.icons").diagnostics.Info,
		diagnostic_hint = require("setup.ui.icons").diagnostics.Hint,
	},
})
