class Reddit
  class Filter
    USEFUL_PARAMS = %w[title score over_18 is_self url]
    def initialize(raw)
      @raw = raw
    end

    def useful
      data.map{ |post|
        post['data'].select{ |k, _|
          USEFUL_PARAMS.include? k
        }
      }
    end

    def data
      @data ||= JSON.parse(@raw)['data']['children']
    end
  end

  class Converter
    def initialize(reddit_hash)
      @reddit_hash = reddit_hash
    end

    def to_giflist_params
      @reddit_hash.map do |rh|
        GifListEntry.new(rh).to_h
      end.compact
    end
  end

  class GifListEntry
    def initialize(reddit_hash)
      @reddit_hash = reddit_hash
    end

    def to_h
      return if rejectable?
      {
        nsfw: nsfw,
        title: title,
        url: url,
        published_at: (no_autopublish? ? nil : Time.now.to_s)
      }
    end
  private
    def nsfw
      rh['over_18'] || rh['title'].to_s.downcase.match(/nsfw|nsfl/)
    end

    def url
      url = rh['url']
      @no_autopublish = true unless url.match(/\.gif$/)
      url
    end

    def title
      rh['title'].gsub(/\(.*\)/i, '').gsub(/\[.*\]/i, '')[0..254]
    end

    def no_autopublish?
      @no_autopublish ||= begin
        [/reddit/i, /i thought/i, /r\//i, /upvot/i, /downvot/i, /repost/i, /karma/i, /frontpage/i, /front page/i, /cake day/i, /xpost/i].any? do |pattern|
          rh['title'].match(pattern)
        end || rh['title'].size > 255 || rh['score'].to_i < 40
      end
    end

    def rejectable?
      rh['url'].match(/youtube|liveleak/) || rh['url'].match(/jpg$/)  || rh['url'].match(/png$/)
    end

    def rh
      @reddit_hash
    end
  end

  BASE_URL = "http://www.reddit.com/r/"
  def initialize(subreddit)
    @subreddit = subreddit
  end

  def top
    response = RestClient.get url('/top')
    params = Filter.new(response).useful
    Converter.new(params).to_giflist_params
  end

  def front
    response = RestClient.get url('')
    params = Filter.new(response).useful
    Converter.new(params).to_giflist_params
  end

private

  def url(type)
    "#{BASE_URL}#{@subreddit}#{type}.json"
  end
end
