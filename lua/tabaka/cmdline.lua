local C = require('tabaka.defaults').constants
local V = require('tabaka.action')
local Cat = require('tabaka.action.catalog')
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

      local actions = Cat.get_all_actions()
      local names_actions = vim.tbl_map(function (action)
        return action.name
      end, actions)

      if -- complete the first argument.
        count_sep == 1
        then -- should return a list of action names.
        if cword == '' then return names_actions end
        local matches = {}
        for _, name_action in ipairs(names_actions) do
          if name_action:sub(1, #cword) == cword then
            matches[#matches+1] = name_action
          end
        end
        return matches
      end

      if -- complete the second argument.
        count_sep == 2
        then -- should return the objects defined by each action.
        -- the input action name might not be valid.
        local name_action_input = words[2]
        if #vim.tbl_filter(function (action)
            return action.name == name_action_input
          end, actions) == 0
          then
          return {}
        end
        -- each action knows how to get its own objects.
        return V.run_with_context(
          vim.tbl_filter(function (action)
            return action.name == name_action_input
          end, actions)[1],
          'object'
        )
      end
      return {} -- don't provide completion for #args > 2.
    end
  })
end


return M
