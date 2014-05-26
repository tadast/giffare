$ ->
  $(document).on 'click', '.js_gif_submit', (e) ->
    gif = $(e.currentTarget).closest('.editable_gif')
    gif.find(".page").slideUp()

  $(document).on "ajax:success", 'form.edit_gif', (e) ->
    gif = $(e.currentTarget).closest('.editable_gif')
    gif.find(".done").slideDown()
