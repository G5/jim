class Jim::FeaturesController < Jim::ApplicationController
  def index
    @features = Jim::FeatureManager.instance.features
  end
end
