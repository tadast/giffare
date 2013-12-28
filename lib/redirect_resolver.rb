module RedirectResolver
  def self.process(uri_str, limit = 3)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess     then response.uri
    when Net::HTTPRedirection then process(response['location'], limit - 1)
    else
      response.error!
    end
  rescue SocketError => e
    Rails.logger.error e.message
  end
end
