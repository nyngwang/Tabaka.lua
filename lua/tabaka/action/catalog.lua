local P = require('tabaka.filepath')
local M = {
  modname_action = {},
  filepath_head = '',
}
function M.__register_modname(modname)
  M.modname_action = vim.split(modname, '%.')
  M.filepath_head = P.get_filepath_module_from_modname(M.modname_action)
end


function M.get_current_filetype()
  -- TODO:
  -- Internally, we use the value returned from this function as
  -- the default value for the first index of `M.action` when the value
  -- is missing in the context. In the future, we can provide a command
  -- to change the return value, and thus swap the entire set of commands.
  return 'markdown'
end


function M.get_all_actions(pattern_filetype)
  local names_folders = vim.tbl_map(function (name_folder)
    return vim.fn.fnamemodify(name_folder, ':h:t')
  end, vim.fn.globpath(M.filepath_head, '*/', false, true))

  if not pattern_filetype then
    pattern_filetype = M.get_current_filetype()
  end
  if type(pattern_filetype) == 'string' then
    names_folders = vim.tbl_filter(function (name_folder)
      return name_folder:match(pattern_filetype)
    end, names_folders)
  end
  local actions = {}

  for _, name_folder in ipairs(names_folders) do
    local modname_folder = table.concat({ table.concat(M.modname_action, '.'), name_folder }, '.')
    for _, action in ipairs(require(modname_folder)) do
      actions[#actions+1] = action
    end
  end

  return actions
end


return M
