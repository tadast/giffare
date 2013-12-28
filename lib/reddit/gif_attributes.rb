class Reddit::GifAttributes
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
