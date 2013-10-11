class SitemapController < ApplicationController
  layout nil
  respond_to :xml

  def index
    scoped = Gif.visible.ordered
    last_gif = scoped.last
    if stale?(etag: last_gif, last_modified: last_gif.updated_at.utc)
      respond_to do |format|
        format.xml { @gifs = scoped }
      end
    end
  end
end