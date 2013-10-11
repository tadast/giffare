$ ->
  $(document).on "ajax:success", 'form.edit_gif', (e) ->
    gif = $(e.currentTarget).closest('.editable_gif')
    gif.find(".page").slideUp()
    gif.find(".done").slideDown()