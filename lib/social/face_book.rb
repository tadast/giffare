module Social
  class FaceBook
    delegate :client, to: :auth

    def initialize(content = nil)
      @content = content
    end

    def auth
      @auth ||= FbGraph::Auth.new(ENV['FB_APP_ID'], ENV['FB_APP_SECRET'])
    end

    def share
      if @content.present?
        page.feed!(access_token: giffare_account.access_token, message: @content)
      end
    end

    def page
      @page ||= FbGraph::Page.new(giffare_account.identifier)
    end

  private

    def giffare_account
      @giffare_account ||= admin.accounts.select{ |a| a.name.match(/giffare/i) }.first
    end

    def admin
      @admin ||= begin
        user = FbGraph::User.me(ENV['FB_ACCESS_TOKEN'])
        user.fetch
        user
      end
    end
  end
end
