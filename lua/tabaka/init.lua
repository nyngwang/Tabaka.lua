-- PLUGIN PLAN:
--
--
-- tabaka should follow these invariants:
-- - it should not create/delete any markdown file implicitly
-- - it should open the correct markdown file for each tabpage
--   - after reordering of tabpage
--   - after restoring from a session
--     - NOTE: `tabnr == tabid` for every tabpage after restoring a session
-- - it should execute an editing commands only if the tabaka window is presented
--
--
-- tabaka can create & maintain markdown files for users
-- - a user needs to call the creation command before using tabaka
--   - notify the user the markdown has NOT been created
--   - notify the user the markdown has been created
-- - a user can choose a template to use for the underlying markdown
--
--
-- tabaka can be customized by the following properties:
-- - a user can define the width of the tabaka window
-- - a user can define the position of the tabaka window (left/right/top/down)
-- - a user can supply a custom template for the markdown, instead of the default one
--   - a user can define custom placeholder for each template
--
--
-- tabaka will create user commands, `:tabaka commands`, for the following use cases:
-- - a user can create the markdown for the current tabpage
-- - a user can toggle the markdown as the very-{top,down,left,right} fixed-{width,height} window
-- - a user can modify the markdown easily (tabaka<=nvim)
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
local L = require('tabaka.cmdline')
local M = {}


function M.setup(opts)
  -- create user commands after setup.
  L.create_user_commands()
end


return M
