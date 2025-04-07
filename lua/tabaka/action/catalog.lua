local W = require('tabaka.window')
local P = require('tabaka.filepath')
local M = {
  modname_action = {},
  filepath_head = '',
}
function M.__register_modname(modname)
  M.modname_action = vim.split(modname, '%.')
  M.filepath_head = P.get_filepath_module_from_modname(M.modname_action)
end


function M.get_filetype_buf_tabaka()
  if W.get_winid_tabaka()[1] then
    local bufnr_win_tabaka = vim.api.nvim_win_get_buf(W.get_winid_tabaka()[2])
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr_win_tabaka })
    return #filetype > 0 and filetype or 'none'
  end
  return 'none'
end


function M.get_all_actions(pattern_filetype)
  local names_folders = vim.tbl_map(function (name_folder)
    return vim.fn.fnamemodify(name_folder, ':h:t')
  end, vim.fn.globpath(M.filepath_head, '*/', false, true))

  local actions = {}

  for _, name_folder in ipairs(names_folders) do
    local modname_folder = table.concat({ table.concat(M.modname_action, '.'), name_folder }, '.')
    for _, action in ipairs(require(modname_folder)) do
      actions[#actions+1] = action
    end
  end

  if not pattern_filetype then
    pattern_filetype = M.get_filetype_buf_tabaka()
  end

  actions = vim.tbl_filter(function (action)
    return action.filetype == 'common'
      or action.type == 'create'
      or action.filetype:match(pattern_filetype)
  end, actions)

  return actions
end


return M
