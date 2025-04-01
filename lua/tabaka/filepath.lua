local C = require('tabaka.defaults').constants
local M = {}


function M.create_file(filepath)
  vim.cmd(([[
    !touch %s
  ]]):format(filepath))
end


function M.get_filepath_tabaka_runtime()
  local paths_rt_plugins = vim.split(vim.o.runtimepath, ',')
  for _, path in ipairs(paths_rt_plugins) do
    if path:match(('/%s$'):format(C.NAME_PROJECT)) then
      return path
    end
  end
  -- TODO: raise an error.
  print('Tabaka: Internal error, plugin runtime not found.')
  return ''
end


function M.get_filepath_user_project_folder_tabaka()
  return ('%s/%s'):format(vim.fn.getcwd(-1,-1), C.NAME_PROJECT_FOLDER)
end


function M.get_filepath_user_project_markdown_tabaka()
  return ('%s/%s.md'):format(M.get_filepath_user_project_folder_tabaka(), C.NAME_MARKDOWN)
end


function M.folder_or_file_exist(filepath)
  if not filepath then
    return false
  end
  local did, _, code = os.rename(filepath, filepath)
  return did or (code == 13)
end


return M
