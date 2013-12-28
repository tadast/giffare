class Reddit::AttributeFilter
  USEFUL_PARAMS = %w[title score over_18 is_self url]

  def initialize(data)
    @data = data
  end

  def useful
    @data.map{ |p| p['data'].slice(*USEFUL_PARAMS) }
  end
end
