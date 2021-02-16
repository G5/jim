RSpec.configure do |config|
  config.before(:each) do |example|
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

      conflicting_features = (enabled_features & Jim::Rspec.permanently_disabled)
      unless conflicting_features.empty?
        raise "You're trying to enable some permanently disabled features: '#{conflicting_features.inspect}'"
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

      allow_any_instance_of(Jim::FeatureManager).to receive(:enabled?) do |feature_id|
        Jim::FeatureManager.instance.find_by_id(feature_id)
        !disabled_features.include?(feature_id)
      end
    elsif !has_enabled
      allow_any_instance_of(Jim::FeatureManager).to receive(:enabled?) do |feature_id|
        Jim::FeatureManager.instance.find_by_id(feature_id)
        !Jim::Rspec.permanently_disabled.include?(feature_id)
      end
    end
  end
end
