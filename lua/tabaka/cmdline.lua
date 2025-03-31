local C = require('tabaka.defaults').constants
local V = require('tabaka.action')
local M = {}


function M.create_user_commands()
  vim.api.nvim_create_user_command(C.NAME_COMMAND, function (opts)
    local fargs = opts.fargs
    if #fargs > 2 then return end
    V.dispatcher_command(fargs)
  end, {
    nargs = '*',
    complete = function (cword, cmdline)
      local count_sep = 0
      if -- a space follows the cursor.
        cmdline:match('%s$')
        then -- we found a sep.
        count_sep = count_sep + 1
      end
      local words = vim.split(vim.trim(cmdline), '%s+')
      count_sep = count_sep + (#words - 1)

      if -- no argument.
        count_sep == 0
        then return {} end

      local actions = vim.tbl_keys(V.action)

      if -- complete the first argument.
        count_sep == 1
        then -- should return a list of actions.
        if cword == '' then return actions end
        local matches = {}
        for _, action in ipairs(actions) do
          if action:sub(1, #cword) == cword then
            matches[#matches+1] = action
          end
        end
        return matches
      end

      if -- complete the second argument.
        count_sep == 2
        then -- should return the objects defined by each action.
        -- the first argument should be an action, but need check.
        local action = words[2]
        if not V.action[action] then return {} end
        if -- the action takes no argument.
          not V.object[action]
          then return {} end
        return V.object[action]()
      end
      return {} -- don't provide completion for #args > 2.
    end
  })
end


return M
