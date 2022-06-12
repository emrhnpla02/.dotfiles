local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("emrhnpla.lsp.lsp-installer")
require("emrhnpla.lsp.handlers").setup()
require("emrhnpla.lsp.null-ls")
require("emrhnpla.lsp.lspsaga")
