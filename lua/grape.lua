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

local wrapper_rg_opts = {
	"python3",
	script_path(),
	"rg",
}

local default_rg_opts = {
	"-L",
	"--no-heading",
	"--with-filename",
	"--line-number",
	"--column",
	"--smart-case",
}

local grape_telescope_ui_options = {
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
}

function M.live_grape(opts)
    local given_opts = opts or {}
    local merged_opts = vim.tbl_deep_extend("keep", given_opts, {
        vimgrep_arguments = default_rg_opts,
        override_telescope_ui = true,
    })

    merged_opts.vimgrep_arguments = vim.tbl_flatten({ wrapper_rg_opts, merged_opts.vimgrep_arguments })

    if merged_opts.override_telescope_ui then
        merged_opts = vim.tbl_deep_extend("keep", merged_opts, grape_telescope_ui_options)
    end

	require("telescope.builtin").live_grep(merged_opts)
end

return M
