class Reddit
  DEFAULTS = [
    OpenStruct.new(name: 'gifs', section: ''),
    OpenStruct.new(name: 'gifs', section: '/top'),
    OpenStruct.new(name: 'AnimalsBeingJerks', section: '/top'),
  ]
  def initialize(subreddits: DEFAULTS)
    @subreddits = subreddits
  end

  def import
    persist
    share_best
  end

  def persist
    @persisted ||= begin
      attrs = Converter.new(all).giffare_attributes
      Gif.create(attrs)
    end
  end

  def share_best
    shareable = persisted_sharable_gifs.select{ |gif|
      gif.url.in? best_urls
    }
    Social.share(shareable)
  end

private

  def best_urls
    @best_urls ||= all.sort_by{ |h|
      h["score"]
    }.last(4)
    .map{ |h| h['url'] }
  end

  def persisted_sharable_gifs
    persist.reject{ |gif|
      gif.nsfw || gif.published_at.nil? || gif.new_record?
    }
  end

  def all
    @subreddits.flat_map { |sr|
      Fetch.new(sr.name, sr.section).process
    }
  end
end
