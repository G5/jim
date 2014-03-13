class Jim::FeatureManager
  def self.instance
    @instance ||= new(YAML.load_file(Rails.root.join("config", "features.yml")))
  end

  def initialize(feature_hash)
    @feature_hashes = feature_hash["features"]
    @enabled_features = []

    if @feature_hashes.present?
      @feature_ids = @feature_hashes.map do |feature_hash|
        feature_hash["id"]
      end.map(&:to_sym)
    else
      @feature_ids = []
    end
  end

  def features
    @feature_hashes
  end

  def enabled?(feature_id)
    raise Jim::UnknownFeatureError.new(feature_id) unless @feature_ids.include?(feature_id)
    @enabled_features.include?(feature_id)
  end

  def enable(feature_id)
    @enabled_features << feature_id
  end
end
