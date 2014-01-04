module Social
  def self.share(gifs)
    Array(gifs).each do |gif|
      url = url_for(gif)
      content = "#{gif.title}\n\n#{url}"
      if ENV['SOCIAL_SHARE']
        return if gif.shared?
        Tweet.new(content).delay.share
        FaceBook.new(url, gif.title).delay.share
        gif.update_column(:shared, true)
      else
        puts "Social sharing is off, set SOCIAL_SHARE to true to enable"
      end
      # google plus...
    end
  end

private

  def self.url_for(gif)
    Rails.application.routes.url_helpers.gif_url gif.id, host: ENV['HOST']
  end
end
