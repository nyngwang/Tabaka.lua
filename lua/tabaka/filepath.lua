local C = require('tabaka.defaults').constants
local M = {}


function M.create_file(filepath)
    vim.cmd(([[
      !touch %s
    ]]):format(filepath))
end


function M.get_filepath_project_folder_tabaka()
  return ('%s/%s'):format(vim.fn.getcwd(-1,-1), C.NAME_PROJECT_FOLDER)
end


function M.get_filepath_markdown_tabaka()
  return ('%s/%s.md'):format(M.get_filepath_project_folder_tabaka(), C.NAME_MARKDOWN)
end


function M.folder_or_file_exist(filepath)
  if not filepath then
    return false
  end
  local did, _, code = os.rename(filepath, filepath)
  return did or (code == 13)
end


return M
