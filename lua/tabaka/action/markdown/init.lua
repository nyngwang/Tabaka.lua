return {
  {
    filetype = 'markdown',
    type = 'create',
    name = 'create_with_template',
    action = require('tabaka.action.markdown.create_with_template')[1],
    object = require('tabaka.action.markdown.create_with_template')[2],
  },
  {
    filetype = 'markdown',
    type = 'window',
    name = 'toggle_window',
    action = require('tabaka.action.markdown.toggle_window')[1],
    object = require('tabaka.action.markdown.toggle_window')[2],
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'update_task_title',
    action = function () end,
    object = function () return {} end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'update_task_details',
    action = function () end,
    object = function () return {} end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'pin_note',
    action = function () end,
    object = function () return { '1', '2' } end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'add_note',
    action = function () end,
    object = function ()
      -- example1: already 3 notes, add_note 2, then note 2 the new note.
      -- example2: already 3 notes, add_note $, then note 4 the new note.
      return { '1', '2', '$' }
    end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'delete_note',
    action = function () end,
    object = function () return { '1', '2' } end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'add_buffer',
    action = function () end,
    object = function () return { '42', '69' } end,
  },
  {
    filetype = 'markdown',
    type = 'edit',
    name = 'delete_buffer',
    action = function () end,
    object = function () return { '42', '69' } end,
  },
}
