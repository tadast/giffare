# https://github.com/nov/fb_graph#normal-oauth2-flow
module Social
  class FBUtils
    attr_reader :client
    def initialize(fb = Social::FaceBook.new)
      @client = fb.client
      @auth = fb.auth
    end

    # ment to be called from the console
    def new_access_code
      client.redirect_uri = 'http://giffare.com/callback'
      uri = client.authorization_uri(:scope => [:create_note, :manage_pages])
      puts "Visit: #{uri}"
      `open "#{uri}"`
      puts "Get code param and call #from_code with it"
    end

    def from_code(code)
      client.authorization_code = code
      short_life_token = client.access_token!(:client_auth_body).to_s
      long_life_token  = @auth.exchange_token!(short_life_token).access_token.to_s
      admin = admin(long_life_token)
      page = admin.accounts.select{ |a| a.name.match(/giffare/i) }.first
      puts "FB_PAGE_ID#{page.identifier}"
      puts "FB_PAGE_ACCESS_TOKEN=#{page.access_token}"
      page.access_token
    end

  private

    def admin(token)
      user = FbGraph::User.me(token)
      user.fetch
      user
    end
  end
end
