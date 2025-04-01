local W = require('tabaka.window')
local M = {}


-- HOW-TO-USE:
--
-- M.action['markdown']['create']['create_with_template'][1]
--           ^1          ^2        ^3                     ^4
-- Where:
-- 1: the first layer is the document type; we only support markdown for now.
-- 2: the second layer is the command category, e.g. editing commands.
-- 3: the third layer is the name of the action, e.g. toggle_window.
-- 4: the fourth layer is the [action,objects]-pair; both are functions.
M.action = {
  markdown = {
    create = {
      create_with_template = require('tabaka.action.create_with_template'),
    },
    window = {
      toggle_window = require('tabaka.action.toggle_window'),
    },
    edit = {
      update_task_title = {
        function () end,
        function () return {} end,
      },
      udpate_task_details = {
        function () end,
        function () return {} end,
      },
      add_note = {
        function () end,
        function ()
          -- example1: already 3 notes, add_note 2, then note 2 the new note.
          -- example2: already 3 notes, add_note $, then note 4 the new note.
          return { '1', '2', '$' }
        end,
      },
      delete_note = {
        function () end,
        function () return { '1', '2' } end,
      },
      pin_note = {
        function () end,
        function () return { '1', '2' } end,
      },
      add_buffer = {
        function () end,
        function () return { '42', '69' } end,
      },
      delete_buffer = {
        function () end,
        function () return { '42', '69' } end,
      },
    },
  },
}


function M.get_current_filetype()
  -- NOTE:
  -- we use this function to avoid specifying the filetype for every command.
  -- in the future, a user will need to call a command to set "the current filetype",
  -- and that change "the entire set" of command completions.

  -- we only support `markdown` for now.
  return 'markdown'
end


function M.get_actions_all_cats(filetype)
  if -- the caller does not know the context.
    not filetype
    then -- use the internal default.
    filetype = M.get_current_filetype()
  end

  local actions_all = {}
  for _, actions in pairs(M.action[filetype]) do
    for k, v in pairs(actions) do
      actions_all[k] = v
    end
  end
  return actions_all
end


function M.dispatch_command(fargs)
  local argc = #fargs
  if -- is the laziest command.
    argc == 0 then
    M.action[M.get_current_filetype()].window.toggle_window[1]({})
    return
  end

  local action = fargs[1]
  local actions = M.get_actions_all_cats()

  if -- action is not valid.
    not actions[action] then
    -- TODO: but we should allow a command like `:Baka vsplit L`.
    print(('Tabaka: No such action: %s'):format(action))
    return
  end

  local args_action = { unpack(fargs, 2) }
  if argc == 1
    then -- special case for `{nil}`.
    args_action = {}
  end

  if -- the tabaka window does not exist.
    not W.get_window_tabaka()[1]
    and -- it's an editing command.
    M.action[M.get_current_filetype()].edit[action]
    then -- abort editing commands.
    print(('Tabaka: Failed to run command: %s, toggle the window first.'):format(action))
    return
  end

  if argc == 2
    then -- still need to check the provided object is valid.
    local objects_valid = actions[action][2](M.get_current_filetype())
    local arg_action = args_action[1]
    local found = false
    for _, o in ipairs(objects_valid) do
      if arg_action == o then found = true end
    end
    if not found then
      print(('Tabaka: Failed to run command: %s, invalid argument: %s'):format(action, arg_action))
      return
    end
  end

  -- finally, peacefully...
  actions[action][1](args_action, M.get_current_filetype())
end


return M

