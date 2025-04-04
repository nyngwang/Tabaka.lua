--[[
PLUGIN PLAN:

tabaka can provide the following functionalities:
- [ ] for each tabpage, a user can {toggle} the tabaka window on one of the {top,bottom,left,right}-side
  - [ ] a user can only toggle {one} tabaka window at a time for each tabpage
  - [ ] open the tabaka window send the cursor into it
  - [ ] close the tabaka window put the cursor back to where it was
- [ ] for each tabpage, a user can {link} {one} file on each of the {top,bottom,left,right}-side
  - [ ] to {link} a file to one of the sides, open the file in the tabaka window on that side
  - [ ] the {create} command is available inside the tabaka window to create a file from {bundled,provided} template
  - [ ] the linked file will be shown when the tabaka window is toggled on that side
- [ ] for each tabpage, everything still work after {tabpage-reordering,session-restoring}
  - close a tabpage will not delete those linked files, but no way to restore the state
- [ ] for each tabpage, only {filetype} commands of the linked file will be available
  - [ ] if there is no tabaka window, only the {toggle} command will be available

tabaka should follow these invariants:
- it should not create/delete any markdown file implicitly

tabaka can be customized by the following properties:
- [ ] a user can define the width/height of the tabaka window on each side of a tabpage
- [ ] a user can supply custom templates for a filetype

END OF PLUGIN PLAN
]]
local L = require('tabaka.cmdline')
local M = {}


function M.setup(opts)
  -- create user commands after setup.
  L.create_user_commands()
end


return M
