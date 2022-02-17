function _C(a, b, c)
    return a and b or c;
end

function _M(module, func)
    return function(...)
        return func(module, ...);
    end
end

function _M2(module, func)
    return function(...)
        return module[func](module, ...);
    end
end
