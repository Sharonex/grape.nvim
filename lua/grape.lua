local M = {}

function script_path()
	local script_runner_name = "rg_runner.py"
	local cwd = debug.getinfo(2, "S").source:sub(2)

	local lastSeparator = cwd:match(".*/")

	if lastSeparator then
		-- Replace everything after the last separator with the new file name
		local newA = cwd:sub(1, #lastSeparator) .. "../" .. script_runner_name
		return newA
	else
		-- Handle the case where there is no directory separator in the path
		print("Invalid path")
		return cwd:match("(.*/)")
	end
end

local default_opts = {
	"python3",
	script_path(),
	"rg",
	"-L",
	"--no-heading",
	"--with-filename",
	"--line-number",
	"--column",
	"--smart-case",
}

function M.live_grape()
	require("telescope.builtin").live_grep({
		vimgrep_arguments = default_opts,
		winblend = 10,
		extensions = {
			file_browser = { layout_strategy = "horizontal", sorting_strategy = "ascending" },
			heading = { treesitter = true },
			["ui-select"] = { require("telescope.themes").get_dropdown({}) },
		},
		cache_picker = { num_pickers = 10 },
		dynamic_preview_title = true,
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				width = 0.9,
				height = 0.9,
				preview_height = 0.6,
				preview_cutoff = 0,
			},
		},
		path_display = { "smart", shorten = { len = 3 } },
		wrap_results = true,
	})
end

return M
