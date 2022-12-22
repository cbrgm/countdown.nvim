local M = {}

-- Declare variables for the timer, seconds remaining in the countdown, and the configuration.
local timer
local seconds_remaining = 0
local config = {
  default_minutes = 25,
}

-- Formats a given number of seconds into hours, minutes, and seconds.
-- @param seconds The number of seconds to format.
-- @return A string in the format "HH:MM:SS".
local function format_time(seconds)
  local hours = string.format("%02d", math.floor(seconds / 3600))
  local minutes = string.format("%02d", math.floor((seconds % 3600) / 60))
  local seconds = string.format("%02d", seconds % 60)
  return hours .. ":" .. minutes .. ":" .. seconds
end

-- Decrements the seconds remaining and stops the timer if necessary.
local function countdown_callback()
  seconds_remaining = seconds_remaining - 1
  if seconds_remaining <= 0 then
    print("Time is up!")
    timer:stop()
    timer = nil
  end
end

-- Gets the current time remaining in the countdown.
-- @return A string in the format "HH:MM:SS" if the countdown is ongoing, or nil if the countdown is not ongoing.
local function get_time()
  if seconds_remaining > 0 then
    return format_time(seconds_remaining)
  end
  return ""
end

-- Starts a countdown with the given number of minutes.
-- If the minutes parameter is not a positive integer, the default number of minutes specified in the config will be used instead.
-- If the default number of minutes is not set or is not a positive integer, an error message will be printed.
-- @param minutes The number of minutes for the countdown.
local function start_countdown(minutes)
  if minutes == nil then
    minutes = config.default_minutes
  end
  if minutes <= 0 and config.default_minutes then
    minutes = config.default_minutes
  end
  if minutes <= 0 then
    print("Error: Countdown duration must be a positive integer.")
    return
  end
  seconds_remaining = minutes * 60
  timer = vim.loop.new_timer()
  timer:start(1000, 1000, countdown_callback)
end

-- Stops the current countdown.
local function stop_countdown()
  if timer then
    timer:stop()
    timer = nil
  end
end

-- Resumes the current countdown if it has been paused.
local function resume_countdown()
  if not timer and seconds_remaining > 0 then
    timer = vim.loop.new_timer()
    timer:start(1000, 1000, countdown_callback)
  end
end

-- Resets the current countdown with the given number of minutes.
-- If the minutes parameter is not a positive integer, the default number of minutes specified in the config will be used instead.
-- If the default number of minutes is not set or is not a positive integer, an error message will be printed.
-- @param minutes The number of minutes for the countdown.
local function resetCountdown(minutes)
  stop_countdown()
  start_countdown(minutes)
end

-- Expose the stop_countdown, resume_countdown, start_countdown, and get_time functions as methods of the M table.
M.stop_countdown = stop_countdown
M.resume_countdown = resume_countdown
M.start_countdown = resetCountdown
M.get_time = get_time
M.config = config

-- Registers the four commands "CountdownStop", "CountdownResume", "CountdownStart", and "CountdownTime" with Neovim.
-- The "CountdownStart" command takes an optional argument for the number of minutes in the countdown.
-- If no argument is provided, the default number of minutes specified in the config will be used instead.
function M.setup(c)

  vim.api.nvim_create_user_command("CountdownStop", function()
    M.stop_countdown()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("CountdownResume", function()
    M.resume_countdown()
  end, { nargs = 0 })

  vim.api.nvim_create_user_command("CountdownStart", function(args)
    local minutes = args["args"] or nil
    if minutes == nil then
      M.start_countdown(M.config.default_minutes)
    else
      M.start_countdown(tonumber(minutes))
    end
  end, { nargs = '?' })

  vim.api.nvim_create_user_command("CountdownTime", function()
    print(M.get_time())
  end, { nargs = 0 })
  config = vim.tbl_deep_extend('force', config, c)
end

-- Return the M table.
return M
