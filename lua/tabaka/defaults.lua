local M = {}


M.constants = {
  NAME_PROJECT = 'Tabaka.lua',
  NAME_FOLDER_PROJECT = '.tabaka',
  NAME_MARKDOWN = 'baka',
  NAME_COMMAND = 'Baka',
}


M.default_opts = {
  callback = {
    on_open = {
      function (args)
        local h_edtior = vim.api.nvim_get_option_value('lines', { scope = 'global' })
        local w_editor = vim.api.nvim_get_option_value('columns', { scope = 'global' })

        if args.HJKL == 'K' then
          vim.api.nvim_win_set_height(args.winid, math.floor(h_edtior/4))
        elseif args.HJKL == 'J' then
          vim.api.nvim_win_set_height(args.winid, math.floor(h_edtior/3))
        else
          vim.api.nvim_win_set_width(args.winid, math.floor(w_editor/5))
        end
      end
    }
  }
}


return M
