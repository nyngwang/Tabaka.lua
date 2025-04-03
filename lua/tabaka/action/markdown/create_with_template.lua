local U = require('tabaka.utils')
local P = require('tabaka.filepath')


return {
  function (args)
    local filetype = args.self.filetype
    local name_template = args[1]
    local path_template = table.concat({ P.get_filepath_folder_template_project_tabaka(filetype), name_template }, P.sep)
    local tabid_current = vim.api.nvim_get_current_tabpage()
    local tabnr_current = vim.api.nvim_tabpage_get_number(tabid_current)

    -- TODO: prompt user before creating the file.
    P.copy_file_into_folder_and_rename(
      path_template,
      P.get_filepath_folder_tabaka_project_user(),
      ('%d_%d.%s'):format(tabnr_current, tabid_current, U.ft_to_ext[filetype])
    )
  end,
  function (args)
    local filetype = args.self.filetype
    local path_folder_template = P.get_filepath_folder_template_project_tabaka(filetype)
    return vim.tbl_map(function (path_abs)
      return vim.fn.fnamemodify(path_abs, ':t')
    end, vim.fn.globpath(path_folder_template, '*', false, true))
  end,

}
