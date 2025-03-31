local W = require('tabaka.window')
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


function M.toggle_window_tabaka()
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
end


function M.dispatcher_command(fargs)
  -- TODO: update after testing.
  M.toggle_window_tabaka()
end


return M
