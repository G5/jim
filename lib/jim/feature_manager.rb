class Jim::FeatureManager
  def self.instance
    @instance ||= new(YAML.load_file(Rails.root.join("config", "features.yml")))
  end

  attr_reader :features

  def initialize(configuration)
    feature_hashes = configuration["features"]
    @features ||= []

    if feature_hashes.present?
      feature_hashes.each do |feature_hash|
        feature = Jim::Feature.new(feature_hash["id"].to_sym)
        feature.description = feature_hash["description"]
        @features << feature

        if feature_hash["enablements"].present?
          feature_hash["enablements"].each do |enablement_hash|
            feature.add_enablement(enablement_hash)
          end
        end
      end
    end
  end

  def find_by_id(feature_id)
    feature = @features.detect { |f| f.id == feature_id }
    raise Jim::UnknownFeatureError.new(feature_id) unless feature.present?
    feature
  end

  def add_dependency(feature_id, name, description)
    feature = find_by_id(feature_id)
    feature.add_dependant(
      Jim::Dependant.new(name, description)
    )
  end
end
