class Reddit::AttributeFilter
  USEFUL_PARAMS = %w[title score over_18 is_self url]

  def initialize(data)
    @data = data
  end

  def useful
    @data.map do |p|
      params = p['data'].slice(*USEFUL_PARAMS)
      params['url'] = ImgurDirect.new(params['url']).urls.first
      params
    end
  end
end
