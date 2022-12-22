# Countdown Timer for Neovim

This plugin provides a countdown timer for Neovim that can be started, stopped, resumed, and reset with either lua functions or user commands. The remaining time is displayed in the format `hh:mm:ss`.

**Motivation**: My motivation for creating this plugin was to have an easy-to-use countdown timer for Pomodoro technique sessions in Nvim.

## Installation

```lua
  use { 'cbrgm/countdown.nvim', config = function()
    require("countdown").setup({
      default_minutes = 25, -- The default minutes to use when a countdown is started without minutes specified
    })
  end }
```

## Example usage with Lualine

Sample usage displaying the countdown with [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

```lua
-- function returns a formatted string hh:mm:ss
local timer = function()
	return require("countdown").get_time()
end

lualine.setup {
	sections = {},
	inactive_sections = {},
	tabline = {
    -- add the timer to the tabline bar
		lualine_x = { timer, "encoding", "fileformat", "filetype" },
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
}
```

## Keybindings

Sample key bindings:

```lua
vim.api.nvim_set_keymap('n', '<leader>ttn', function()
	require("countdown").start_countdown(25)
end, { desc = "Start Pomodoro session" })

vim.api.nvim_set_keymap('n', '<leader>ttb', function()
	require("countdown").start_countdown(5)
end, { desc = "Start Pomodoro break" })

vim.api.nvim_set_keymap('n', '<leader>tts', function()
	require("countdown").stop_countdown()
end, { desc = "Stop Countdown" })

vim.api.nvim_set_keymap('n', '<leader>ttr', function()
	require("countdown").resume_countdown()
end, { desc = "Resume Countdown" })
```

## Lua Functions

The following lua functions are available for starting, stopping, resuming, and resetting the countdown timer:

```lua
local countdown = require('countdown')

-- Starts/Resets the countdown with a specified number of minutes
countdown.start_countdown(minutes)

-- Stop the countdown if it is currently running
countdown.stop_countdown()

-- Resume the countdown if it is currently stopped
countdown.resume_countdown()

-- Get the countdowns time as string in format hh:mm:ss
countdown.get_time()
```

## User Commands

The following user commands are available for starting, stopping, resuming, and resetting the countdown timer:

```
" Start/Reset the countdown for a specified number of minutes
:CountdownStart minutes

" Stop the countdown if it is currently running
:CountdownStop

" Resume the countdown if it is currently stopped
:CountdownResume

```

## Default Configuration

You can configure the default number of minutes to use when starting the countdown with a value less than or equal to zero.

```lua
countdown.setup({
  default_minutes = 25, -- The default minutes to use when a countdown is started without specifing minutes
})
```

## License

This plugin is licensed under the MIT License. See the LICENSE file for details.
