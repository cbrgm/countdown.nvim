local M = {}

local timer
local seconds_remaining
local config = {
  default_minutes = 25,
  countdown_direction = "down",
}

local function format_time(seconds)
  local hours = string.format("%02d", math.floor(seconds / 3600))
  local minutes = string.format("%02d", math.floor((seconds % 3600) / 60))
  local seconds = string.format("%02d", seconds % 60)
  return hours .. ":" .. minutes .. ":" .. seconds
end

local function countdown_callback()
  if config.countdown_direction == "down" then
    seconds_remaining = seconds_remaining - 1
    if seconds_remaining == 0 then
      print("Time is up!")
      timer:stop()
      timer = nil
    else
      print("Time remaining: " .. format_time(seconds_remaining))
    end
  else
    seconds_remaining = seconds_remaining + 1
    print("Time elapsed: " .. format_time(seconds_remaining))
  end
end

local function getTime()
  if seconds_remaining then
    if config.countdown_direction == "down" then
      return "Time remaining: " .. format_time(seconds_remaining)
    else
      return "Time elapsed: " .. format_time(seconds_remaining)
    end
  end
end

local function startCountdown(minutes)
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

local function stopCountdown()
  if timer then
    timer:stop()
    timer = nil
  end
end

local function resumeCountdown()
  if not timer and seconds_remaining then
    timer = vim.loop.new_timer()
    timer:start(1000, 1000, countdown_callback)
  end
end

local function resetCountdown(minutes)
  stopCountdown()
  startCountdown(minutes)
end

function M.setup(c)
  vim.api.nvim_create_user_command("Countdown", "StopCountdown", { nargs = 0 })
  vim.api.nvim_create_user_command("Countdown", "ResumeCountdown", { nargs = 0 })
  vim.api.nvim_create_user_command("Countdown", "ResetCountdown", { nargs = 1 })
  vim.api.nvim_create_user_command("Countdown", "GetTime", { nargs = 0 })
  config = vim.tbl_deep_extend('force', config, c)
end

M.StopCountdown = stopCountdown
M.ResumeCountdown = resumeCountdown
M.StartCountdown = resetCountdown
M.GetTime = getTime

return M
