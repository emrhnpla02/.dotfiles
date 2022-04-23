local status_ok, dap = pcall(require, "dap")
if not status_ok then
	return
end

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

-- Javascript/Node
dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/.config/dap/vscode-node-debug2/out/src/nodeDebug.js" },
}

dap.configurations.javascript = {
	{
		name = "Launch",
		type = "node2",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
	{
		-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		name = "Attach to process",
		type = "node2",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
}

-- Javascript/Firefox
dap.adapters.firefox = {
	type = "executable",
	command = "node",
	args = { os.getenv("HOME") .. "/.config/dap/vscode-firefox-debug/dist/adapter.bundle.js" },
}

dap.configurations.typescript = {
	name = "Debug with Firefox",
	type = "firefox",
	request = "launch",
	reAttach = true,
	url = "http://localhost:3000",
	webRoot = "${workspaceFolder}",
	firefoxExecutable = "/usr/bin/firefox",
}

-- .NET
dap.adapters.coreclr = {
	type = "executable",
	command = "/usr/bin/netcoredbg",
	args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
		end,
	},
}
