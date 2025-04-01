local C = require('tabaka.defaults').constants
local M = {}


local get_filepath_tabaka_runtime = function ()
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


function M.create_file(filepath)
  vim.cmd(([[
    !touch %s
  ]]):format(filepath))
end


function M.copy_file_into_folder_and_rename(path_file_src, path_folder, filename_new)
  local path_file_new = ('%s/%s'):format(path_folder, filename_new)

  local file_src = io.open(path_file_src, 'rb')
  if not file_src then print('Tabaka: Internal error, cannot read template file.') return end

  local content_file_src = file_src:read('*a')
  file_src:close()

  local file_new = io.open(path_file_new, 'wb')
  if not file_new then print('Tabaka: Internal error, cannot write template file.') return end
  file_new:write(content_file_src)
  file_new:close()
end


function M.get_filepath_tabaka_folder_template(filetype)
  return ('%s/template/%s'):format(get_filepath_tabaka_runtime(), filetype)
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
