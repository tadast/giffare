class ImgurDirect
  class Api
    API_URI   = URI.parse('https://api.imgur.com')
    CLIENT_ID = "Client-ID #{ENV['IMGUR_CLIENT_ID']}"
    API_VERSION = 3

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def urls(image_id)
      request_uri = "#{API_URI.request_uri}#{API_VERSION}/#{@endpoint}/#{image_id}"
      request  = Net::HTTP::Get.new(request_uri)
      request.add_field('Authorization', CLIENT_ID)

      response = web_client.request(request).body

      data = JSON.parse(response)
      if data['success'] && data['data']['images']
        data['data']['images'].map{ |img| img['link'] }
      elsif data['success']
        Array(data['data']['link'])
      else
        raise data.to_s
      end
    end

  private

    def web_client
      http = Net::HTTP.new(API_URI.host, API_URI.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE # Ain't nobody got time for that :(
      http
    end

  end
end
