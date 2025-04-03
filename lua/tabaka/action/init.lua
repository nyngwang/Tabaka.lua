local W = require('tabaka.window')
local Cat = require('tabaka.action.catalog')
Cat.__register_modname(...)
local M = {}


function M.run_with_context(caller, method, ...)
  return caller[method] {
    self = caller,
    ...
  }
end


function M.dispatch_command(fargs)
  local argc = #fargs
  local actions = Cat.get_all_actions()
  local name_action_input = fargs[1]

  if -- the command is `:Baka`.
    argc == 0 then
    -- WARN: we assume that action `toggle_window` should be defined by every filetype.
    M.run_with_context(
      vim.tbl_filter(function (action)
        return action.name == 'toggle_window'
      end, actions)[1],
      'action'
    )
    return
  end
  -- now argc >= 1.

  if -- not found action name.
    #vim.tbl_filter(function (action)
      return action.name == name_action_input
    end, actions) == 0 then
    -- TODO: but we should allow a command like `:Baka vsplit L`.
    print(('Tabaka: No such action: %s'):format(name_action_input))
    return
  end
  -- found action name.

  if -- there is no tabaka window under the current tabpage.
    not W.get_window_tabaka()[1]
    and -- it's an editing command.
    #vim.tbl_filter(function (action)
      return action.type == 'edit'
      and action.name == name_action_input
    end, actions) == 1
    then -- abort it.
    print(('Tabaka: Failed to run editing command: %s, toggle the window first.'):format(name_action_input))
    return
  end

  -- packing args received from the user.
  local args_action = argc == 1 and {}
    or -- argc >= 2.
    { unpack(fargs, 2) }

  if -- the action name is followed by an object.
    argc == 2
    then -- validate the object.
    local objects_valid = M.run_with_context(
      vim.tbl_filter(function (action)
        return action.name == name_action_input
      end, actions)[1],
      'object'
    )
    local arg_action = args_action[1]
    local found = false
    for _, o in ipairs(objects_valid) do
      if arg_action == o then found = true end
    end
    if not found then
      print(('Tabaka: Failed to run command: %s, invalid object: %s'):format(name_action_input, arg_action))
      return
    end
  end

  -- finally, peacefully...
  M.run_with_context(
    vim.tbl_filter(function (action)
      return action.name == name_action_input
    end, actions)[1],
    'action',
    unpack(args_action)
  )
end


return M
