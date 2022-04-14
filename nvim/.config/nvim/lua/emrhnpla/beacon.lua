local status_ok, beacon = pcall(require, "beacon")
if not status_ok then
	return
end

beacon.setup({
	enable = true,
	size = 40,
	fade = true,
	minimal_jump = 10,
	show_jumps = true,
	focus_gained = false,
	shrink = true,
	timeout = 500,
	ignore_buffers = {},
	ignore_filetypes = {},
})
