-- check required folders & files exist for the current project.
-- - ensure .tabaka/ exist under project root.
-- - ensure .tabaka/main.md exist.
--
--
-- create keymaps for the following user story
-- - a user can `:tabaka commands strings` to do many things
-- - a user can toggle the markdown as the leftmost fixed-width window
-- - (<=) a user can modify the markdown easily
--   - change the task description for the current tabpage
--   - add/del the buffer of the current window
--   - add/del the buffer of the given buffer id
--   - add/del a note-item into the markdown
--     - first prompt the user to enter the location to insert the note-item
--     - second prompt the user to enter the text for the note-item
--   - toggle a note item as done or undone
--
--
-- create autocmds for the following user story
-- - when a user is not editing the markdown
--   - show only the part of the markdown for the current tabpage.
-- - when a user is editing the markdown (engage)
--   - show the raw markdown, scrolled to the part for the current tabpage
--
--
-- create utils to support each user story above
-- - window creator with the following properties
--   - be able to open a fixed-width window
--   - be able to move the window as the leftmost split
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
