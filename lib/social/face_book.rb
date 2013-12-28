module Social
  class FaceBook
    delegate :client, to: :auth

    def initialize(link = nil, title = nil)
      @link = link
      @title = title
    end

    def auth
      @auth ||= FbGraph::Auth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])
    end

    def share
      if @link.present?
        puts "FB: ---\n#{@title}, #{@link}\n---"
        page.feed!(
          access_token: ENV['FB_PAGE_ACCESS_TOKEN'],
          message: @title || "New gif",
          link: @link,
          description: @title || "New gif")
      end
    end

  private

    def page
      @page ||= FbGraph::Page.new(ENV['FB_PAGE_ID'])
    end
  end
end
