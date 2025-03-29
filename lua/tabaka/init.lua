-- PLAN:
--
--
-- invariants in tabaka:
-- - tabaka should not delete any existing section in the markdown implicitly
-- - tabaka should be able to scroll the markdown correctly for each tabpage, after restoring a session
--   - note: we always have `tabnr == tabid` for every tabpage after restoring a session
-- - tabaka should execute a command only-if the tabaka window is open under the current tabpage
--
--
-- tabaka can be customized by the following properties:
-- - a user can define the width of the tabaka window
-- - a user can define the position of the tabaka window (left/right/top/down)
-- - a user can provide a template for the markdown
--   - a user can define custom rules for a template
--
--
-- create user commands, `:tabaka commands`, for the following use cases:
-- - toggle the markdown as the very-{top,down,left,right} fixed-{width,height} window
-- - modify the markdown easily (tabaka<=nvim)
--   - update the task title of the current tabpage
--   - update the task description of the current tabpage
--   - add/del an item in the note list of the current tabpage
--     - first prompt the user for the index to insert after
--     - second prompt the user for the note text
--   - add/del an item in the note list to the "doing"
--   - add/del an item in the note list to the "done"
--   - add/del an item in the buffer list of the current tabpage
--     - use the buffer in the current window
--     - use the buffer id provided by the user
--
--
-- create autocmds to support the features above:
-- - tabaka should be able to scroll the markdown correctly for each tabpage, after restoring a session
--   - when the tabaka window is open under a tabpage
--     - if section not exist, create one using the default or template provided by the user
--     - if section exist, scroll the buffer so that the task title with the first few lines of the tabaka window
--   - when the user move the cursor out of the tabaka window
--     - scroll the buffer so that the task title with the first few lines of the tabaka window
--
--
local U = require('tabaka.utils')
local M = {}


function M.toggle_window_tabaka()
  if -- already presented in the current tabpage.
    U.get_window_tabaka()[1]
    then -- close it.
    -- TODO: the user might not have auto-save plugin!
    vim.api.nvim_win_close(U.get_window_tabaka()[2], false)
    return
  end
  -- otherwise, we try to open the tabaka window.
  local ok, winid_tabaka = U.create_window_tabaka()
  if not ok then return end
  U.setup_window_tabaka(winid_tabaka)
end


return M
