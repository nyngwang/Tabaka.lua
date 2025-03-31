local C = require('tabaka.defaults').constants
local M = {}


M.object = {
  add_note = function ()
    -- example1: already 3 notes, add_note 2, then note 2 the new note.
    -- example2: already 3 notes, add_note $, then note 4 the new note.
    return { '1', '2', '$' }
  end,
  delete_note = function ()
    return { '1', '2' }
  end,
  pin_note = function ()
    return { '1', '2' }
  end,
  add_buffer = function ()
    return { '42', '69' }
  end
}


M.action = {
  update_task_title = function ()
  end,
  udpate_task_details = function ()
  end,
  add_note = function ()
  end,
  delete_note = function ()
  end,
  pin_note = function ()
  end,
  add_buffer = function ()
  end,
}


local dispatcher_command = function (cmdline)
  -- TODO: update after testing.
  require('tabaka').toggle_window_tabaka()
end


function M.create_user_commands()
  vim.api.nvim_create_user_command(C.NAME_COMMAND, function (opts)
    local fargs = opts.fargs

    -- TODO: implement command dispatcher.
    dispatcher_command()
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

      local actions = vim.tbl_keys(M.action)

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
        if not M.action[action] then return {} end
        if -- the action takes no argument.
          not M.object[action]
          then return {} end
        return M.object[action]()
      end
      return {} -- don't provide completion for #args > 2.
    end
  })
end


return M
