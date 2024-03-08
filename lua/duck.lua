local waddle = require('waddle')

local M = {}
M.ducks_list = {}
local conf = { character = "🦆", speed = 10, width = 2, height = 1, color = "none", blend = 100 }
function M.default_conf()
    return table.clone(conf)
end

M.hatch = function(character, speed, color, strategy)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, { character or conf.character })

    local duck = vim.api.nvim_open_win(buf, false, {
        relative = 'cursor', style = 'minimal', row = 1, col = 1, width = conf.width, height = conf.height
    })
    vim.cmd("hi Duck" .. duck .. " guifg=" .. (color or conf.color) .. " guibg=none blend=" .. conf.blend)
    vim.api.nvim_win_set_option(duck, 'winhighlight', 'Normal:Duck' .. duck)

    waddle.waddle(duck, speed, conf, strategy)
end

M.cook = function()
    local last_duck = M.ducks_list[#M.ducks_list]

    if not last_duck then
        vim.notify("No ducks to cook!")
        return
    end

    local duck = last_duck['name']
    local timer = last_duck['timer']
    table.remove(M.ducks_list, #M.ducks_list)
    timer:stop()

    vim.api.nvim_win_close(duck, true)
end

M.cook_all = function()
    if #M.ducks_list <= 0 then
        vim.notify("No ducks to cook!")
        return
    end

    while (#M.ducks_list > 0) do
        M.cook()
    end
end

M.setup = function(opts)
    conf = vim.tbl_deep_extend('force', conf, opts or {})
end

M.custom_waddle = function()
    local custom_waddle = require("custom-waddle")
    custom_waddle.worming_default(conf)
end

return M
