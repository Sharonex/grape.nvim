# grape.nvim 🍇

`grape.nvim` is a Neovim plugin that simplifies the functionality of [Telescope](https://github.com/nvim-telescope/telescope.nvim)'s live_grep by allowing live grep searches with a fuzzy approach for individual words instead of searching for a whole consecutive string with spaces included.

For example, if my project had the string:
I am a human and everyone should love grapes

Grape will allow you to filter for "i love grape" where's in the default Telescope live_grep you would need to:
* filter for the word "grape"
* press <C-f> to stop live grepping
* add the words I love

<img width="1541" alt="Screenshot 2023-11-02 at 16 38 21" src="https://github.com/Sharonex/grape.nvim/assets/10423841/f6444d36-2505-43ed-a5f5-3b1b00b2eadb">

Also, Grape comes with some more comfortable default UI settings(which can be disabled), 
which allow seeing the actual text you're searching for and not the file being filtered.

## Features

- Perform fuzzy searches for individual words during live grep using Telescope.
- Improved search experience for finding non-consecutive words in your codebase.
- Nicer default telescope config

## Installation

### Prerequisites

Before installing `grape.nvim`, ensure you have the following requirements met:

- [Neovim](https://neovim.io) 0.5.0 or higher
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) installed and configured in your Neovim setup.
- [Rg] A requirement for telescope's live_grep
- [Python3] python3 must be installed

## Usage
```
vim.keymap.set("n", "<leader>sp", require('grape').live_grape())
```

## Configuration

```
{
    -- The arguments sent to rg
    vimgrep_arguments = { "-L", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", }

    -- Overrides the default UI settings of telescope
    override_telescope_ui = true,
}

```

### Using a Plugin Manager

You can install `grape.nvim` using your preferred plugin manager. Here are some examples:

```vim
{
    'Sharonex/grape.nvim'
}
```

## Acknowledgments
- Special thanks to the Telescope team for their awesome fuzzy searching functionality.
- Credit to reddit user `neovimser` for the UI configs.

## Contributions
Contributions and feedback are welcome. If you encounter any issues or have suggestions for improvements, please open an issue on the GitHub repository.


