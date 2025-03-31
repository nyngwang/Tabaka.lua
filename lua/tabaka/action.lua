local W = require('tabaka.window')
local M = {}


local get_current_filetype = function ()
  return 'markdown'
end


M.action = {
  -- the first layer is the document type; we only support markdown now.
  markdown = {
    -- the second layer is the command category.
    create = {
      -- the third layer is the command itself.
      create_with_template = {
        -- the fourth layer is a list: [action, object].
        function (args)
        end,
        function ()
        end,
      },
    },
    window = {
      toggle_window = {
        function (args)
          -- TODO: check creation done.

          if -- already presented in the current tabpage.
            W.get_window_tabaka()[1]
            then -- try close it.
            W.close_window_tabaka(W.get_window_tabaka()[2])
            return
          end
          -- otherwise, we try to open the tabaka window.
          local ok, winid_tabaka = W.create_window_tabaka()
          if not ok then return end
          W.load_markdown_in_window(winid_tabaka)
        end,
        function ()
          return { 'H', 'J', 'K', 'L' }
        end,
      }
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


function M.get_actions_all_cats(filetype)
  if -- the caller does not know the context.
    not filetype
    then -- use the internal default.
    filetype = get_current_filetype()
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
    M.action[get_current_filetype()].window.toggle_window[1]({})
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

  local args = { unpack(fargs, 2) }
  if argc == 1
    then -- special case for `{nil}`.
    args = {}
  end

  if -- the tabaka window does not exist.
    not W.get_window_tabaka()[1]
    and -- it's an editing command.
    M.action[get_current_filetype()].edit[action]
    then -- abort editing commands.
    print(('Tabaka: Failed to run command: %s, toggle the window first.'):format(action))
    return
  end


  if argc == 2
    then -- still need to check the provided object is valid.
    local objects_valid = actions[action][2]()
    local arg_action = args[1]
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
  actions[action][1](args)
end


return M
