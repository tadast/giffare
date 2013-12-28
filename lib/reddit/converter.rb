class Reddit::Converter
  def initialize(reddit_hash)
    @reddit_hash = reddit_hash
  end

  def giffare_attributes
    @reddit_hash.map do |rh|
      Reddit::GifAttributes.new(rh).to_h
    end.compact
  end
end
