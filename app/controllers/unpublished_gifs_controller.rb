require 'reddit'
class UnpublishedGifsController < ApplicationController
  include GifsHelper
  http_basic_authenticate_with name: "admin", password: ENV['GIFLIST_ADMIN_PASSWORD']
  respond_to :html, :js, :json, :xml

  def index
    @gifs = Gif.unpublished.ordered.page(params[:page]).per(20)
  end

  def edit
  end

  def update
    if gif.update_attributes(gif_params)
      if gif.social_share
        Social.share gif
      end
      respond_to do |wants|
        wants.html { redirect_to gif }
        wants.js { head :ok }
      end
    end
  end

  def nsfw
    @gifs = Gif.nsfw.unpublished.ordered.page(params[:page]).per(20)
    render template: 'unpublished_gifs/index'
  end

  def new
    @gif = Gif.new
  end

  def create
    gif = Gif.new gif_params
    if gif.save
      redirect_to gif_path(gif)
    else
      render text: gif.errors.full_messages.join
    end
  end

  def destroy
    if gif.destroy
      redirect_to action: :index
    else
      head 500
    end
  end

  def empty_trash
    Gif.in_trash.delete_all
    redirect_to :back
  end

  def delete_all
    Gif.unpublished.delete_all
    redirect_to :back
  end

private
  def gif_params
    params.require(:gif).permit(:title, :url, :nsfw, :published_at, :hidden, :social_share)
  end

end
