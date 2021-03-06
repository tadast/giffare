require 'reddit'
class GifsController < ApplicationController
  include GifsHelper
  http_basic_authenticate_with name: "admin", password: ENV['GIFLIST_ADMIN_PASSWORD'], only: [:nsfw]
  respond_to :html, :js, :json, :xml

  def index
    respond_with gifs
  end

  def show
    @title = gif.title
    @prev_gif = gif.prev
    @next_gif = gif.next
  end

  def random
    redirect_to action: :show, id: Gif.pick_random
  end

  def nsfw
    @gifs = Gif.nsfw.published.ordered.page(params[:page]).per(20)
    render template: 'gifs/index'
  end

  def import
    Reddit.new.delay.import
    if params[:admin]
      redirect_to unpublished_gifs_url
    else
      redirect_to root_url
    end
  end

private
  def admin_helpers?
    cookies.signed[:admin_helpers] == true
  end
  helper_method :admin_helpers?
end
