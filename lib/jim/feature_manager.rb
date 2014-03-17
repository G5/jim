class Jim::FeatureManager
  def self.instance
    @instance ||= new(YAML.load_file(Rails.root.join("config", "features.yml")))
  end

  attr_reader :features

  def initialize(configuration)
    feature_hashes = configuration["features"]
    @features ||= []

    if feature_hashes.present?
      build_features_from_hashes(feature_hashes)
      set_dependencies_from_hashes(feature_hashes)
    end
  end

  def enabled?(feature_id)
    find_by_id(feature_id).enabled?
  end

  def find_by_id(feature_id)
    feature = @features.detect { |f| f.id == feature_id }
    raise Jim::UnknownFeatureError.new(feature_id) unless feature.present?
    feature
  end

  def add_dependency(features, name, description)
    feature_ids = [features].flatten
    feature_ids.each do |feature_id|
      feature = find_by_id(feature_id)
      feature.add_dependant(
        Jim::Dependant.new(name, description)
      )
    end
  end

protected

  def build_features_from_hashes(feature_hashes)
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

  # Called after feature list is built so that one won't depend on another that
  # hasn't been parsed yet.
  def set_dependencies_from_hashes(feature_hashes)
    feature_hashes.each do |feature_hash|
      next unless feature_hash.include?("depends_on")

      dependant = find_by_id(feature_hash["id"].to_sym)
      dependeds_on = [ feature_hash["depends_on"] ].flatten.map(&:to_sym)

      dependeds_on.each do |depended_on_id|
        depended_on = find_by_id(depended_on_id)
        dependant.depends_on(depended_on)
      end
    end
  end
end
