
local M = {}

local default_opts = { "python3", "/Users/sharonavni/projects/nvim/grape.nvim/rg_runner.py", "rg", "-L", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" }

function M.live_grape()
    require("telescope.builtin").live_grep({
        vimgrep_arguments = default_opts,
        winblend = 10,
        extensions = {
            file_browser = {layout_strategy = "horizontal", sorting_strategy = "ascending"},
            heading = {treesitter = true},
            ["ui-select"] = {require("telescope.themes").get_dropdown({})},
        },
        cache_picker = { num_pickers = 10, },
        dynamic_preview_title = true,
        layout_strategy = "vertical",
        layout_config = {
            vertical = {
                width = 0.9,
                height = 0.9,
                preview_height = 0.6,
                preview_cutoff = 0,
            }},
        path_display = {"smart", shorten = {len = 3}},
        wrap_results = true,
    })
end

return M

