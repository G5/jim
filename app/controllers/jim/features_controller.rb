class Jim::FeaturesController < Jim::ApplicationController
  def index
    @features = sorted_features
  end

protected

  def sorted_features
    enabled, disabled = Jim::FeatureManager.instance.features.partition(&:enabled?)
    enabled.sort_by(&:id) + disabled.sort_by(&:id)
  end
end
