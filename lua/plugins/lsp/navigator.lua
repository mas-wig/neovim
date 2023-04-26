return require("navigator").setup({
	border = "single",
	ts_fold = false,
	default_mapping = false,
	transparency = 100,
	lsp_signature_help = false,
	lsp = {
		disable_lsp = "all",
		format_on_save = false,
		diagnostic = {
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 10,
				underline = true,
				update_in_insert = true,
				prefix = "  ",
			},
			severity_sort = true,
		},
		diagnostic_virtual_text = true,
		diagnostic_scrollbar_sign = false,
		diagnostic_update_in_insert = true,
		disply_diagnostic_qf = true,
	},
	icons = {
		diagnostic_err = require("ui.icons").diagnostics.Error,
		diagnostic_warn = require("ui.icons").diagnostics.Warn,
		diagnostic_info = require("ui.icons").diagnostics.Info,
		diagnostic_hint = require("ui.icons").diagnostics.Hint,
	},
})
