module Social
  def self.share(gifs)
    Array(gifs).each do |gif|
      content = "#{gif.title} #{url_for(gif)}"
      puts "Sharing: #{content}"
      Tweet.new(content).share
      # FB...
      # google plus...
    end
  end

private

  def self.url_for(gif)
    Rails.application.routes.url_helpers.gif_url gif, host: ENV['HOST']
  end
end
