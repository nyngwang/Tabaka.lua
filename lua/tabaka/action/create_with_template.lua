local A = require('tabaka.action')
local P = require('tabaka.filepath')


return {
  -- the fourth layer is a list: [action, object].
  function (args)
    local name_template = args[1]
    local path_template = ('%s/%s'):format(P.get_filepath_tabaka_folder_template(A.get_current_filetype()), name_template)
    local tabid_current = vim.api.nvim_get_current_tabpage()
    local tabnr_current = vim.api.nvim_tabpage_get_number(tabid_current)

    -- TODO: prompt user before creating the file.
    P.copy_file_into_folder_and_rename(
      path_template,
      P.get_filepath_user_project_folder_tabaka(),
      ('%d_%d'):format(tabnr_current, tabid_current)
    )
  end,
  function ()
    local path_folder_template = P.get_filepath_tabaka_folder_template(A.get_current_filetype())
    return vim.fn.globpath(path_folder_template, '*', false, true)
  end,

}
