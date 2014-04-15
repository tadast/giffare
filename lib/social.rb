module Social
  def self.share(gifs)
    puts gifs.size
    Array(gifs).each_with_index do |gif, idx|
      url = url_for(gif)
      content = "#{gif.title}\n\n#{url}"
      if ENV['SOCIAL_SHARE']
        return if gif.shared?
        Tweet.new(content).delay(run_at: (idx * 3).minutes.from_now).share
        FaceBook.new(url, gif.title).delay(run_at: (idx * 3).minutes.from_now).share
        gif.update_column(:shared, true)
      else
        puts "Social sharing is off, set SOCIAL_SHARE to true to enable.\n #{content}"
      end
      # google plus...
    end
  end

private

  def self.url_for(gif)
    Rails.application.routes.url_helpers.gif_url gif.id, host: ENV['HOST']
  end
end
