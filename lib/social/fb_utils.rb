# https://github.com/nov/fb_graph#normal-oauth2-flow
module Social
  class FBUtils
    attr_reader :client
    def initialize(client = Social::FaceBook.new.client)
      @client = client
    end

    # ment to be called from the console
    def new_access_code
      client.redirect_uri = 'http://giffare.com/callback'
      uri = client.authorization_uri(:scope => [:create_note, :manage_pages])
      puts "Visit: #{uri}"
      puts "Get code param and call #new_from_code"
    end

    def new_from_code(code)
      client.authorization_code = code
      puts client.access_token!(:client_auth_body).to_s
    end
  end
end
