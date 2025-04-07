--[[
PLUGIN PLAN:

tabaka can provide the following functionalities:
- [v] for each tabpage, a user can {toggle} the tabaka window on one of the {top,bottom,left,right}-side
  - [v] a user can only toggle {one} tabaka window at a time for each tabpage
  - [v] open the tabaka window send the cursor into it
  - [v] close the tabaka window put the cursor back to where it was
- [v] for each tabpage, a user can {link} {one} file on each of the {top,bottom,left,right}-side
  - [v] to {link} a file to one of the sides, open the file in the tabaka window on that side
  - [v] the linked file will be shown when the tabaka window is toggled on that side
- [ ] for each tabpage, only necessary commands will be available
  - [v] the {common} commands are available regardless of a {filetype} file being shown or not
    - [v] the {toggle} command is available anywhere, anytime
  - [ ] the {filetype} commands are available when the tabaka window shows a {filetype} file
    - [ ] the {filetype-create} command is an exception; it is available when the tabaka window is shown
      - [ ] it can create a file from {bundled} templates
      - [ ] it can create a file from {user} templates
- [ ] for each tabpage, everything still works after {tabpage-reordering,session-restoring}
  - close a tabpage will not delete those linked files, but no way to restore the state

tabaka should follow these invariants:
- [ ] it should not create/delete any markdown file implicitly

tabaka can be customized by the following properties:
- [v] a user can define the width/height of the tabaka window on each side of a tabpage

END OF PLUGIN PLAN
]]
local L = require('tabaka.cmdline')
local S = require('tabaka.config')
local M = {}


function M.setup(opts)
  S.setup_opts = opts

  -- create user commands after setup.
  L.create_user_commands()
end


return M
