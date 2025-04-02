local W = require('tabaka.window')
local M = {}


-- HOW-TO-USE:
--
-- First, you need to wrap the raw `M.action` table:
--
-- local action_ft = M.FootprintTable(M.action)
--
-- After that, you can access any underlying function normally:
--
-- action_ft['markdown']['create']['create_with_template'][1]
--            ^1          ^2        ^3                     ^4
--
-- The magic part is that in the function body of the underlying
-- function pair, you can access the value of "N-th index", which
-- is called "footprints", as indicated above, for example:
--
-- {
--   -- the action function.
--   function (args)
--     local filetype = args.footprints[1] -- got 'markdown'.
--   end,
--   -- the object function.
--   ...
-- }
M.FootprintTable = function (cotable, footprints)
  footprints = footprints or {}

  return setmetatable({}, {
    __index = function (t, k)
      local _footprints = {}
      for _, footprint in ipairs(footprints) do
        _footprints[#_footprints+1] = footprint
      end
      local _cotable = cotable and cotable[k] or nil
      return M.FootprintTable(_cotable, _footprints)
    end,
    __call = function (t, args)
      if type(cotable) == 'function' then
        return cotable({
          footprints = footprints,
          unpack(args or {})
        })
      end
      return nil
    end
  })
end


-- HOW-TO-USE:
--
-- M.action['markdown']['create']['create_with_template'][1]
--           ^1          ^2        ^3                     ^4
-- Where:
-- 1: the first  layer is the document type; we only support markdown for now.
-- 2: the second layer is the command category, e.g. editing commands.
-- 3: the third  layer is the name of the action, e.g. toggle_window.
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
  -- TODO:
  -- Internally, we use the value returned from this function as
  -- the default value for the first index of `M.action` when the value
  -- is missing in the context. In the future, we can provide a command
  -- to change the return value, and thus swap the entire set of commands.
  return 'markdown'
end


function M.get_all_actions_by_filetype(footprint, filetype)
  if not filetype then
    filetype = M.get_current_filetype()
  end

  local actions = {}
  for cate, actions_by_cate in pairs(M.action[filetype]) do
    -- NOTE: we lost the footprint of `cate` here.
    for name, pair_fns in pairs(actions_by_cate) do
      actions[name] = pair_fns
    end
  end

  if footprint then
    return M.FootprintTable(actions, { filetype })
  end
  return actions
end


function M.dispatch_command(fargs)
  local argc = #fargs
  local actions = M.get_all_actions_by_filetype(true)
  local action = fargs[1]

  if -- the command is `:Baka`.
    argc == 0 then
    -- WARN: this line asserts that `toggle_window` should be provided by all filetypes.
    actions.toggle_window[1]()
    return
  end
  -- now argc >= 1.

  if not actions[action] then
    -- TODO: but we should allow a command like `:Baka vsplit L`.
    print(('Tabaka: No such action: %s'):format(action))
    return
  end
  -- now action is valid.

  if -- there is no tabaka window under the current tabpage.
    not W.get_window_tabaka()[1]
    and -- it's an editing command.
    M.action[M.get_current_filetype()].edit[action]
    then -- abort it.
    print(('Tabaka: Failed to run editing command: %s, toggle the window first.'):format(action))
    return
  end

  -- packing args received from the user.
  local args_action = {} -- the case: argc == 1
  if argc >= 2 then
    args_action = { unpack(fargs, 2) }
  end

  if -- the action is followed by an object.
    argc == 2
    then -- validate the object.
    local objects_valid = actions[action][2]()
    local arg_action = args_action[1]
    local found = false
    for _, o in ipairs(objects_valid) do
      if arg_action == o then found = true end
    end
    if not found then
      print(('Tabaka: Failed to run command: %s, invalid object: %s'):format(action, arg_action))
      return
    end
  end

  -- finally, peacefully...
  actions[action][1](args_action)
end


return M

