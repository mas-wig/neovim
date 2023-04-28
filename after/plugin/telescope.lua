local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("media_files")
telescope.load_extension("persisted")
