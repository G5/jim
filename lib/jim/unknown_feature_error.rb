class Jim::UnknownFeatureError < StandardError
  def initialize(feature_id)
    @feature_id = feature_id
  end

  def message
    "I don't know about feature '#{@feature_id}'"
  end
end
