module MinistryOfGif
  class Fetch
    URL = "http://ministryofgifs.org/"
    def initialize(limit: 10, resolve_redirects: true, page: 1)
      @limit = limit
      @page = page
      @resolve_redirects = resolve_redirects
    end

    def recent
      @resolve_redirects ? resolved_gif_urls : original_gif_urls
    end

  private

    def resolved_gif_urls
      original_gif_urls.map { |url|
        RedirectResolver.process(url).to_s
      }
    end

    def original_gif_urls
      nok_html = Nokogiri.HTML(html)
      nok_html.search(".inline-tweet-media").first(@limit).map{|i| i.attributes['src'].to_s }
    end

    def html
      RestClient.get(URL + "page/#{@page}")
    end
  end
end
