class Reddit::Fetch
  BASE_URL = "http://www.reddit.com/r/"

  # section '/top', '/new' etc
  def initialize(subreddit, section = '')
    @subreddit = subreddit
    @section = section
  end

  def process
    Reddit::AttributeFilter.new(items_attributes).useful
  end

private

  def items_attributes
    @item_attributes ||= begin
      response = RestClient.get(url(@section))
      JSON.parse(response)['data']['children']
    end
  end

  def url(type)
    "#{BASE_URL}#{@subreddit}#{type}.json"
  end

end
