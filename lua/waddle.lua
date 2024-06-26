local M = {}
M.ducks_list = {}

M.waddle = function(buf, speed, conf, strategy)
  local timer = vim.loop.new_timer()
  local new_duck = { name = buf, timer = timer }
  table.insert(M.ducks_list, new_duck)

  local waddle_period = 1000 / (speed or conf.speed)
  vim.loop.timer_start(timer, 1000, waddle_period, vim.schedule_wrap(function()
    if vim.api.nvim_win_is_valid(buf) then
      local config = vim.api.nvim_win_get_config(buf)
      local col, row = 0, 0
      col, row = config["col"], config["row"]

      local pos = strategy({ row = row, col = col })
      config["row"] = pos.row
      config["col"] = pos.col

      vim.api.nvim_win_set_config(buf, config)
    end
  end))
  return new_duck
end

return M
