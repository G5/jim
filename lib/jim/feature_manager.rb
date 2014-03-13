class Jim::FeatureManager
  def self.instance
    @instance ||= new(YAML.load_file(Rails.root.join("config", "features.yml")))
  end

  def initialize(configuration)
    @feature_hashes = configuration["features"]
    @enabled_features = []

    if @feature_hashes.present?
      @feature_ids = @feature_hashes.map do |feature_hash|
        feature_hash["id"]
      end.map(&:to_sym)

      @feature_hashes.each do |feature_hash|
        if feature_hash["enablements"].present?
          all_true = feature_hash["enablements"].all? do |enablement_hash|
            case enablement_hash["method"]
            when "ruby"
              enablement_hash["class"].constantize.enable?
            when "environment"
              value = ENV[enablement_hash["variable_name"]]
              regex = enablement_hash["matching"]

              value.present? && value.match(regex)
            end
          end

          if all_true
            enable(feature_hash["id"].to_sym)
          end
        end
      end
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
