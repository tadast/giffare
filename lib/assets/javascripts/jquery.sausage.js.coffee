(($, undefined_) ->
  $.widget "cc.sausage",
    options:
      page: ".page"
      content: (i, $page) ->
        "<span class=\"sausage-span\">" + (i + 1) + "</span>"

    _create: ->
      self = this
      $el = self.element
      self.$outer = $el
      self.$inner = (if $.isWindow(self.element.get(0)) then $("body") else $el.children(":first-child"))
      self.$sausages = $("<div class=\"sausage-set\"/>")
      self.sausages = self.$sausages.get(0)
      self.offsets = []
      self.$sausages.appendTo self.$inner
      self._trigger "create"
      return

    _init: ->
      self = this
      self.draw()
      self._update()
      self._events()
      self._delegates()
      self.$sausages.addClass "sausage-set-init"
      self.blocked = false
      self._trigger "init"
      return

    _events: ->
      self = this
      self.hasScrolled = false
      self.$outer.bind("resize.sausage", ->
        self.draw()
      ).bind "scroll.sausage", (e) ->
        self.hasScrolled = true

      setInterval (->
        return  unless self.hasScrolled
        self.hasScrolled = false
        self._update()
      ), 250
      return

    _getCurrent: ->
      self = this
      st = self.$outer.scrollTop() + self._getHandleHeight(self.$outer, self.$inner) / 4
      h_win = self.$outer.height()
      h_doc = self.$inner.height()
      i = 0
      l = self.offsets.length
      while i < l
        unless self.offsets[i + 1]
          return i
        else if st <= self.offsets[i]
          return i
        else return i  if st > self.offsets[i] and st <= self.offsets[i + 1]
        i++
      i

    _delegates: ->
      self = this
      self.$sausages.delegate(".sausage", "hover", ->
        return  if self.blocked
        $(this).toggleClass "sausage-hover"
      ).delegate ".sausage", "click", (e) ->
        e.preventDefault()
        return  if self.blocked
        $sausage = $(this)
        val = $sausage.index()
        o = self.$inner.find(self.options.page).eq(val).offset().top
        self._scrollTo o
        self._trigger "onClick", e,
          $sausage: $sausage
          i: val

        return  if $sausage.hasClass("current")
        self._trigger "onUpdate", e,
          $sausage: $sausage
          i: val

      return

    _scrollTo: (o) ->
      self = this
      $outer = self.$outer
      rate = 2 / 1
      distance = self.offsets[self.current] - o
      duration = Math.abs(distance / rate)
      duration = (if (duration < 600) then duration else 600)
      $outer = $("body, html, document")  if self.$outer.get(0) is window
      $outer.stop(true).animate
        scrollTop: o
      , duration
      return

    _handleClick: ->
      self = this
      return

    _update: ->
      self = this
      i = self._getCurrent()
      c = "sausage-current"

      return  if i is self.current or self.blocked
      self.current = i
      self.$sausages.children().eq(i).addClass(c).siblings().removeClass c
      self._trigger "update"
      return

    _getHandleHeight: ($outer, $inner) ->
      h_outer = $outer.height()
      h_inner = $inner.height()
      h_outer / h_inner * h_outer

    draw: ->
      self = this
      h_win = self.$outer.height()
      h_doc = self.$inner.height()
      $items = self.$inner.find(self.options.page)
      $page = undefined
      s = []
      offset_p = undefined
      offset_s = undefined
      self.offsets = []
      self.count = $items.length
      self.$sausages.detach().empty()
      i = 0

      # while i < self.count
      #   $page = $items.eq(i)
      #   offset_p = $page.offset()
      #   offset_s = offset_p.top / h_doc * h_win
      #   height = h_win / self.count
      #   s.push "<div class=\"sausage" + (if (i is self.current) then " sausage-current" else "") + "\" style=\"height:" + height + "px;top:" + (height * i) + "px;\">" + self.options.content(i, $page) + "</div>"
      #   self.offsets.push offset_p.top
      #   i++
      self.sausages.innerHTML = s.join("")
      self.$sausages.appendTo self.$inner
      return

    block: ->
      self = this
      c = "sausage-set-blocked"
      self.blocked = true
      self.$sausages.addClass c
      return

    unblock: ->
      self = this
      c = "sausage-set-blocked"
      self.$sausages.removeClass c
      self.blocked = false
      return

    destroy: ->
      self = this
      self.$outer.unbind ".sausage"
      self.$sausages.remove()
      return
) jQuery