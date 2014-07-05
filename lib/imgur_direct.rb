class ImgurDirect
  attr_reader :url

  def initialize(url)
    @url = url.to_s.strip
  end

  def urls
    return [] unless resolvable?
    strategy, image_id = strategy_and_id
    if strategy == 'direct_link'
      [url]
    else
      Api.new(strategy).urls(image_id)
    end
  end

  def resolvable?
    pattern = /http(s)?:\/\/((m\.)|((www)\.)|((i)\.))?imgur.com\/(a\/)?[a-zA-Z0-9&]+((\.jpg)|(\.gif)|(\.png))?/i
    pattern =~ url
  end

private

  ALBUM_URL_PATTERN   = /^https?:\/\/(?:www\.)?imgur\.com\/a\/([a-zA-Z0-9]+)/i
  GALLERY_URL_PATTERN = /^https?:\/\/(?:www\.)?imgur\.com\/gallery\/([a-zA-Z0-9]+)/i
  HASHES_PATTERN      = /imgur\.com\/(([a-zA-Z0-9]{5,7}[&,]?)+)/i
  DIRECT_PATTERN      = /^https?:\/\/(www\.)?(i\.)?imgur\.com\/(.{3,7})\.((jpg)|(gif)|(png))/i
  IMAGE_PATTERN       = /^https?:\/\/(www\.)?(i\.)?imgur\.com\/(.{3,7})$/i

  def strategy_and_id
    @_strategy_and_id ||= begin

      case url
      when DIRECT_PATTERN
        return 'direct_link', $3
      when ALBUM_URL_PATTERN
        return 'album', $1
      when GALLERY_URL_PATTERN
        return 'gallery', $1
      when IMAGE_PATTERN
        return 'image', $3
      when HASHES_PATTERN
        return 'image', $1
      else
        raise "Unknown imgur url pattern"
      end

    end
  end

  def strategy
    strategy, _ = strategy_and_id
    strategy
  end
end
