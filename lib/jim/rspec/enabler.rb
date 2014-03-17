RSpec.configure do |config|
  config.before(:each) do
    has_enabled = example.metadata.keys.include?(:enabled_features)
    enabled_features = example.metadata[:enabled_features]

    has_disabled = example.metadata.keys.include?(:disabled_features)
    disabled_features = example.metadata[:disabled_features]

    if has_disabled && has_enabled
      raise "I don't support enabled and disabled metadata at the same time!"
    end

    if has_enabled && enabled_features.present?
      unless enabled_features.is_a?(Array)
        raise "enabled_features metdata requires an array of feature IDs!"
      end

      enabled_features.each do |feature_id|
        Jim::FeatureManager.instance.find_by_id(feature_id)
        Jim::FeatureManager.instance.
          stub(:enabled?).
          with(feature_id).
          and_return(true)
      end
    elsif has_disabled
      unless disabled_features.is_a?(Array)
        raise "disabled_features metdata requires an array of feature IDs!"
      end

      Jim::FeatureManager.instance.stub(:enabled?) do |feature_id|
        Jim::FeatureManager.instance.find_by_id(feature_id)
        !disabled_features.include?(feature_id)
      end
    elsif !has_enabled
      Jim::FeatureManager.instance.stub(:enabled?) do |feature_id|
        Jim::FeatureManager.instance.find_by_id(feature_id)
        true
      end
    end
  end
end
