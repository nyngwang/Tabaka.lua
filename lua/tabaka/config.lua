local D = require('tabaka.defaults')
local M = {
  setup_opts = {},
}


local function Proxy(surface, fallback)

  return setmetatable({}, {
    __index = function (t, k)
      -- assert fallback is a table.

      if k == 'for_all' then
        local fns_fallback = { __on_internal = 'for_all' }
        for _, v in ipairs(fallback) do
          if type(v) == 'function' then
            fns_fallback[#fns_fallback+1] = v
          end
        end
        local fns_surface = {}
        if type(surface) == 'table' then
          for _, v in ipairs(surface) do
            fns_surface[#fns_surface+1] = v
          end
        end
        surface = { for_all = fns_surface }
        fallback = { for_all = fns_fallback }
      end

      if type(fallback[k]) ~= 'table'
        then -- end of recursive.
        if surface
          and type(surface[k]) == type(fallback[k])
          then
          return surface[k]
        end
        return fallback[k]
      end
      -- fallback[k] is a table.
      if type(surface) == 'table' then
        if type(surface[k]) == 'table' then
          return Proxy(surface[k], fallback[k])
        end
        -- surface[k] is not a table.
        if type(surface[k]) == 'function' then
          -- special case: (fn, [fn,...]).
          if type(fallback[k][1]) == 'function' then
            return Proxy({ surface }, fallback[k])
          end
        end
        -- pass down, look up.
      end
      -- surface is not a table.
      return Proxy(nil, fallback[k])
    end,
    __call = function (t, args)
      if fallback.__on_internal
        then -- found internal keywords.
        if fallback.__on_internal == 'for_all' then
          for _, fn in ipairs(fallback) do fn(args) end
          for _, fn in ipairs(surface) do fn(args) end
        end
        return
      end
      -- return the tables in the middle of indexing.
      return surface, fallback
    end
  })
end


function M.get_opts()
  return Proxy(M.setup_opts, D.default_opts)
end


return M
