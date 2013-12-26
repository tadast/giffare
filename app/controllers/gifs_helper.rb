module GifsHelper

  def self.included(c)
    if defined?(c.helper_method)
      c.helper_method :gif, :gifs
    end
  end

private
  def gif
    @gif ||= Gif.find params[:id]
  end

  def gifs
    @gifs ||= Gif.by_params params
  end
end
