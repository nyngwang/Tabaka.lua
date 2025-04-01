local U = require('tabaka.utils')
local P = require('tabaka.filepath')


return {
  function (args, filetype)
    local name_template = args[1]
    local path_template = ('%s/%s'):format(P.get_filepath_tabaka_folder_template(filetype), name_template)
    local tabid_current = vim.api.nvim_get_current_tabpage()
    local tabnr_current = vim.api.nvim_tabpage_get_number(tabid_current)

    -- TODO: prompt user before creating the file.
    P.copy_file_into_folder_and_rename(
      path_template,
      P.get_filepath_user_project_folder_tabaka(),
      ('%d_%d.%s'):format(tabnr_current, tabid_current, U.ft_to_ext[filetype])
    )
  end,
  function (filetype)
    local path_folder_template = P.get_filepath_tabaka_folder_template(filetype)
    return vim.tbl_map(function (path_abs)
      return vim.fn.fnamemodify(path_abs, ':t')
    end, vim.fn.globpath(path_folder_template, '*', false, true))
  end,

}
