jQuery( ->
  if $('#gifs').length
    $('.pagination').hide()
    loading_indicator = $('#loading_indicator')
    nearBottomOfPage = ->
      $(window).scrollTop() > $(document).height() - $(window).height() - 500
    page = 1
    loading = false
    $(window).scroll ->
      return if loading
      if nearBottomOfPage()
        loading = true
        loading_indicator.show()
        page++
        $.ajax
          url: location.pathname
          data:
            page: page
          type: "get"
          dataType: "script"
          success: ->
            $(window).sausage "draw"
            loading_indicator.hide()
            loading = false

    $(window).sausage()
    $(document).ajaxComplete ->
      try
        FB.XFBML.parse();
      catch ex
        # nom nom
)
