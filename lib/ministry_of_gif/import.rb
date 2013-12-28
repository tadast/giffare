module MinistryOfGif
  class Import
    def initialize(args = {})
      @args = args
    end

    def persist
      Gif.create(
        Fetch.new(@args).recent.map { |url|
          { url: url, published_at: Time.zone.now }
        }
      )
    end
  end
end
