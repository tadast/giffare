class Reddit
  DEFAULTS = [
    OpenStruct.new(name: 'gifs', section: ''),
    OpenStruct.new(name: 'gifs', section: '/top'),
    OpenStruct.new(name: 'AnimalsBeingJerks', section: '/top'),
    OpenStruct.new(name: 'funny', strict: true),
    OpenStruct.new(name: 'funny', section: '/top', strict: true),
    OpenStruct.new(name: 'Unexpected', strict: true),
    OpenStruct.new(name: 'Unexpected', section: '/top', strict: true),
  ]

  def self.import_and_enqueue
    new.import
    delay(run_at: 20.minutes.from_now).import_and_enqueue
  end

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
    @best_urls ||= all.select{ |h|
      h["score"].to_i >= 1000
    }.map{ |h| h['url'] }
  end

  def persisted_sharable_gifs
    persist.reject{ |gif|
      gif.nsfw || gif.published_at.nil? || gif.new_record?
    }
  end

  def all
    @subreddits.flat_map { |sr|
      f = Fetch.new(sr.name, sr.section).process
      f.select!{ |h| h['url'].match(/\.gif$/) } if sr.strict
      f
    }
  end
end
