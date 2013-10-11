require 'reddit'
class GifsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: ENV['GIFLIST_ADMIN_PASSWORD'], only: [:edit, :create, :destroy, :update, :nsfw, :nsfw_unpublished, :unpublished, :new]
  respond_to :html, :js, :json, :xml

  def index
    respond_with gifs
  end

  def show
    @title = gif.title
    @prev_gif = gif.prev
    @next_gif = gif.next
  end

  def edit
  end

  def random
    redirect_to action: :show, id: Gif.pick_random
  end

  def update
    if gif.update_attributes(params[:gif])
      respond_to do |wants|
        wants.html { redirect_to gif }
        wants.js { head :ok }
      end
    end
  end

  def nsfw
    @gifs = Gif.nsfw.published.ordered.page(params[:page]).per(20)
    render template: 'gifs/index'
  end

  def nsfw_unpublished
    @gifs = Gif.nsfw.unpublished.ordered.page(params[:page]).per(20)
    render template: 'gifs/bulk_edit'
  end

  def new
    @gif = Gif.new
  end

  def unpublished
    @gifs = Gif.unpublished.ordered.page(params[:page]).per(20)
    render template: 'gifs/bulk_edit'
  end

  def create
    gif = Gif.new params[:gif]
    if gif.save
      head :ok
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

  def import
    Gif.create Reddit.new('gifs').front
    Gif.create Reddit.new('gifs').top
    Gif.create Reddit.new('AnimalsBeingJerks').top
    if params[:admin]
      redirect_to action: :unpublished
    else
      redirect_to root_url
    end
  end

private
  def gif
    @gif ||= Gif.find params[:id]
  end
  helper_method :gif

  def gifs
    @gifs ||= Gif.by_params params
  end
  helper_method :gifs
end
