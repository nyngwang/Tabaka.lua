local P = require('tabaka.filepath')


return {
  -- the fourth layer is a list: [action, object].
  function (args)
    -- TODO: duplicate the markdown template into project folder.
    print('Tabaka mock: markdown has been created.')
    print('The filepath of create_with_template.lua:', P.get_filepath_tabaka_folder_template())
  end,
  function ()
    -- TODO: should scan the template folder.
    return { 'template1.md', 'template2.md' }
  end,

}
