local M = {}

local timer
local seconds_remaining = 0
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
    end
  else
    seconds_remaining = seconds_remaining + 1
  end
end

local function get_time()
  if seconds_remaining then
    if config.countdown_direction == "down" then
      return format_time(seconds_remaining)
    else
      return format_time(seconds_remaining)
    end
  end
end

local function start_countdown(minutes)
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

local function stop_countdown()
  if timer then
    timer:stop()
    timer = nil
  end
end

local function resume_countdown()
  if not timer and seconds_remaining then
    timer = vim.loop.new_timer()
    timer:start(1000, 1000, countdown_callback)
  end
end

local function resetCountdown(minutes)
  stop_countdown()
  start_countdown(minutes)
end

M.stop_countdown = stop_countdown
M.resume_countdown = resume_countdown
M.start_countdown = resetCountdown
M.get_time = get_time

function M.setup(c)
  vim.api.nvim_create_user_command("CountdownStop", function()
    M.stop_countdown()
  end, { nargs = '?' })
  vim.api.nvim_create_user_command("CountdownResume", function()
    M.resume_countdown()
  end, { nargs = '?' })
  vim.api.nvim_create_user_command("CountdownReset", function(args)
    local minutes = args["args"] or nil
    if not minutes then
      M.start_countdown(config.default_minutes)
    else
      M.start_countdown(minutes)
    end
  end, { nargs = '?' })
  vim.api.nvim_create_user_command("CountdownTime", function()
    print(M.get_time())
  end, { nargs = '?' })
  config = vim.tbl_deep_extend('force', config, c)
end

return M
