COLORS = {
    black = {0, 0, 0},
    white = {1,1,1},
    red = {1, 0, 0},
    orange = {1, 69/255, 0},
    lime = {0, 1, 0},
    green = {0, .5, 0},
    olive = {.5, .5, 0},
    yellow = {1, 1, 0},
    cyan = {0,1,1},
    magenta = {1, 0, 1},
    blue = {0,0,1},
    periwinkle = {.5, 0, 1}
}


function protectTable(tbl)
    return setmetatable({}, {
        __index = tbl,
        __newindex = function(t, key, value)
            error("attempting to change constant " ..
                   tostring(key) .. " to " .. tostring(value), 2)
        end
    })
end

COLORS = protectTable(COLORS)