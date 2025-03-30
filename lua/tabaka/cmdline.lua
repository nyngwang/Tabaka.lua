local C = require('tabaka.defaults').constants
local M = {}


local dispatcher_command = function (cmdline)
  -- TODO: update after testing.
  require('tabaka').toggle_window_tabaka()
end


function M.create_user_commands()
  vim.api.nvim_create_user_command(C.NAME_COMMAND, function (opts)
    print('opts:', vim.inspect(opts))
    -- local fargs = opts.fargs
    -- print('fargs[2...N]:', unpack(fargs,2))

    -- TODO: implement command dispatcher.
    dispatcher_command()
  end, {
    nargs = '*',
    complete = function (foo, line)
      print('foo:', vim.inspect(foo))
      print('line:', vim.inspect(line))
      return {}
    end
  })
end


return M
