module Social
  def self.share(text)
    Tweet.new(text).share
    # FB...
    # google plus...
  end
end
