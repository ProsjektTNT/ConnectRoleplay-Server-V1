function string:split(sep)
    local data, index = {}, 0;

    for str in self:gmatch("([^"..sep.."]+)") do
        index = index + 1;
        data[index] = str;
    end

    return data;
end

function table:assign(target)
    for k, v in next, target do
        self[k] = _C(type(v) == "table" and type(self[k]) == "table", table.assign(self[k], v), v);
    end

    return self;
end

function table:map(callback)
    local data = {};

    for k, v in next, self do
        data[k] = callback(v, k);
    end

    return data;
end

function table:filter(callback)
    local data = {};

    for k, v in next, self do
        if callback(v, k) then
            data[k] = v;
        end
    end

    return data;
end

function table:keys(sep)
    local data, i = {}, 0;

    for k, v in next, self do
        i = i + 1;
        data[i] = k;
    end

    return _C(sep ~= nil, table.concat(data, sep), data);
end

function table:fetch(targets)
    local data = {};

    for _, v in next, targets do
        data[v] = targets[v];
    end

    return data;
end

function table:indexOf(target)
    for k, v in next, self do
        if v == target then
            return k;
        end
    end

    return -1;
end