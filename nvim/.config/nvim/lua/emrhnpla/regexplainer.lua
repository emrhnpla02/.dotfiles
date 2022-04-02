local status_ok, regexplainer = pcall(require, "regexplainer")
if not status_ok then
	return
end

regexplainer.setup({
	-- 'narrative'
	mode = "narrative",

	-- automatically show the explainer when the cursor enters a regexp
	auto = false,

	-- Whether to log debug messages
	debug = false,

	-- 'split', 'popup', 'pasteboard'
	display = "popup",

	mappings = {
		-- toggle = "gR",
		-- examples, not defaults:
		-- show = 'gS',
		-- hide = 'gH',
		-- show_split = 'gP',
		-- show_popup = 'gU',
	},

	narrative = {
		separator = "\n",
	},
})
