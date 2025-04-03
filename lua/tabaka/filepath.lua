local C = require('tabaka.defaults').constants
local U = require('tabaka.utils')
local M = {
  sep = package.config:sub(1,1)
}


function M.create_file(filepath)
  -- TODO: does this work on Windows?
  vim.cmd(([[
    !touch %s
  ]]):format(filepath))
end


function M.filepath_exist(filepath)
  if not filepath then
    return false
  end
  local did, _, code = os.rename(filepath, filepath)
  return did or (code == 13)
end


function M.get_filepath_root_project_tabaka()
  local paths_plugins_rt = vim.split(vim.o.runtimepath, ',')
  for _, path in ipairs(paths_plugins_rt) do
    if path:match(
      U.escape_pattern(M.sep .. C.NAME_PROJECT)
      .. '$'
    ) then
      return path
    end
  end
  -- TODO: raise an error.
  print('Tabaka: Internal error, plugin runtime not found.')
  return ''
end


function M.get_filepath_module_from_modname(modname)
  if type(modname) == 'string' then
    modname = vim.split(modname, '%.')
  end
  if type(modname) ~= 'table' then
    return ''
  end

  return table.concat(
    { M.get_filepath_root_project_tabaka(), 'lua', unpack(modname) },
    M.sep
  )
end


function M.get_filepath_folder_template_project_tabaka(filetype)
  return table.concat({ M.get_filepath_root_project_tabaka(), 'template', filetype }, M.sep)
end


function M.get_filepath_folder_tabaka_project_user()
  return table.concat({ vim.fn.getcwd(-1,-1), C.NAME_FOLDER_PROJECT }, M.sep)
end


function M.get_filepath_markdown_tabaka_project_user()
  return table.concat({
    M.get_filepath_folder_tabaka_project_user(),
    ('%s.md'):format(C.NAME_MARKDOWN),
  }, M.sep)
end


function M.copy_file_into_folder_and_rename(filepath_src, filepath_folder_dest, filename)
  local filepath_dest = table.concat({ filepath_folder_dest, filename }, M.sep)
  local b_file_src = io.open(filepath_src, 'rb')
  if not b_file_src then print('Tabaka: Internal error, cannot read template file.') return end

  local b_content_file_src = b_file_src:read('*a')
  b_file_src:close()

  local b_file_dest = io.open(filepath_dest, 'wb')
  if not b_file_dest then print('Tabaka: Internal error, cannot write template file.') return end
  b_file_dest:write(b_content_file_src)
  b_file_dest:close()
end


return M
