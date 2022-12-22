# Countdown Timer for Neovim

This plugin provides a countdown timer for Neovim that can be started, stopped, resumed, and reset with either lua functions or user commands. The remaining time is displayed in the format `hh:mm:ss`.

## Installation

```
use {'cbrgm/countdown.nvim', config = function()
  countdown.setup({
    default_minutes = 25, -- The default minutes to use
    countdown_direction = "down", -- The direction, whether to count "up" or "down"
  })
end}
```

## Lua Functions

The following lua functions are available for starting, stopping, resuming, and resetting the countdown timer:

```lua
local countdown = require('countdown')

-- Starts/Resets the countdown with a specified number of minutes
countdown.StartCountdown(minutes)

-- Stop the countdown if it is currently running
countdown.StopCountdown()

-- Resume the countdown if it is currently stopped
countdown.ResumeCountdown()

-- Get the countdowns time as string in format hh:mm:ss
countdown.GetTime()
```

## User Commands

The following user commands are available for starting, stopping, resuming, and resetting the countdown timer:

```
" Start the countdown for a specified number of minutes
:Countdown start minutes

" Stop the countdown if it is currently running
:Countdown stop

" Resume the countdown if it is currently stopped
:Countdown resume

" Reset the countdown with a specified number of minutes
:Countdown reset minutes
```

## Default Configuration

You can configure the default number of minutes to use when starting the countdown with a value less than or equal to zero, and the direction of the countdown (either "up" or "down"):

```lua
countdown.setup({
  default_minutes = 25, -- The default minutes to use
  countdown_direction = "down", -- The direction, whether to count "up" or "down"
})
```

## License

This plugin is licensed under the MIT License. See the LICENSE file for details.
```
