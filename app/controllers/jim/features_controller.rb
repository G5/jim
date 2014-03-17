class Jim::FeaturesController < Jim::ApplicationController
  def index
    @features = sorted_features
  end

protected

  def sorted_features
    features = Jim::FeatureManager.instance.features
    enabled, disabled = features.partition(&:enabled?)
    depended_disabled, disabled = disabled.partition do |f|
      f.enabled?(include_depended: false)
    end

    enabled.sort_by(&:id) + depended_disabled.sort_by(&:id) + disabled.sort_by(&:id)
  end
end
