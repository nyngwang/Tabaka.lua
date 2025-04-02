local C = require('tabaka.defaults').constants
local V = require('tabaka.action')
local M = {}


function M.create_user_commands()
  vim.api.nvim_create_user_command(C.NAME_COMMAND, function (opts)
    local fargs = opts.fargs
    if #fargs > 2 then return end
    V.dispatch_command(fargs)
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

      local actions = V.get_all_actions_by_filetype()
      local keys_actions = vim.tbl_keys(actions)

      if -- complete the first argument.
        count_sep == 1
        then -- should return a list of action names.
        if cword == '' then return keys_actions end
        local matches = {}
        for _, action in ipairs(keys_actions) do
          if action:sub(1, #cword) == cword then
            matches[#matches+1] = action
          end
        end
        return matches
      end

      if -- complete the second argument.
        count_sep == 2
        then -- should return the objects defined by each action.
        -- we expect the first argument to be an action, but who knows?
        local action = words[2]
        if not actions[action] then return {} end
        -- each action knows how to get its own objects.
        return V.get_all_actions_by_filetype(true)[action][2]()
      end
      return {} -- don't provide completion for #args > 2.
    end
  })
end


return M
