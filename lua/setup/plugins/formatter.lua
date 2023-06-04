local ok, formatter = pcall(require, "formatter")

if not ok then
	return
end

formatter.setup({
	filetype = {
		["lua"] = { require("formatter.filetypes.lua").stylua },
		["html"] = { require("formatter.filetypes.html").prettier },
		["css"] = { require("formatter.filetypes.css").prettier },
		["rust"] = { require("formatter.filetypes.rust").rustfmt },
		["php"] = { require("formatter.filetypes.php").php_cs_fixer },
		-- ["sql"] = { require("formatter.filetypes.sql").pgformat },
		["json"] = { require("formatter.filetypes.json").prettier },
		["go"] = { require("formatter.filetypes.go").goimports },
	},
})
