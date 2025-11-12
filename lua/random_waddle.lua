local M = {}

function M.get_random()
  -- replace this function if you want to control the random values
  return math.random()
end

-- this is the default waddlw
function M.random_waddle(self)
  return function(duck)
    local row = duck.row
    local col = duck.col

    local angle = 2 * math.pi * self:get_random()
    local sin = math.sin(angle)
    local cos = math.cos(angle)

    if row < 0 and sin < 0 then
      row = vim.o.lines
    end

    if row > vim.o.lines and sin > 0 then
      row = 0
    end

    if col < 0 and cos < 0 then
      col = vim.o.columns
    end

    if col > vim.o.columns and cos > 0 then
      col = 0
    end

    return { row = row + 0.5 * sin, col = col + 1 * cos }
  end
end

function M.favor_top_right(self)
  return function(duck)
    local row = duck.row
    local col = duck.col

    local go_bottom = false
    if row < vim.o.lines * 0.7 then
      go_bottom = self:get_random() > 0.7
      if go_bottom then
        return { row = row + 0.5, col = col }
      end
    end

    local go_right = false
    if col < vim.o.columns * 0.7 then
      go_right = self:get_random() > 0.7
      if go_right then
        return { row = row, col = col - 1 }
      end
    end

    return self.random_waddle(self)(duck)
  end
end

return M
