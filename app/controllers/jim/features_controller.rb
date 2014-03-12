class Jim::FeaturesController < Jim::ApplicationController
  def index
    @features = YAML.load_file(Rails.root.join("config", "features.yml"))["features"]
  end
end
