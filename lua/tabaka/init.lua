local L = require('tabaka.cmdline')
local S = require('tabaka.config')
local A = require('tabaka.autocmd')
local M = {}


function M.setup(opts)
  S.setup_opts = opts

  -- create user commands after setup.
  L.create_user_commands()
  A.create_user_autocmds()
end


return M
