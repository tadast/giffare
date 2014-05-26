require 'reddit'
class GifSearchResultsController < ApplicationController
  respond_to :html, :js, :json, :xml

  def index
  end

private
  def gifs
    @gifs ||= Gif.search(params[:q]).limit(100)
  end
  helper_method :gifs

  def admin_helpers?
    false
  end
  helper_method :admin_helpers?
end
