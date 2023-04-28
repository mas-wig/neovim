if vim.version().minor >= 9 then
	vim.loader.enable()
end
local function safeRequire(module)
	local success, req = pcall(require, module)
	if success then
		return req
	end
	local msg = "Error loading " .. module
	local notifyInstalled, notify = pcall(require, "notify")
	if notifyInstalled then
		notify(" " .. msg, vim.log.levels.ERROR)
	else
		print(msg)
	end
end

safeRequire("wiggy.options")
safeRequire("wiggy.lazy")
safeRequire("wiggy.mappings")
