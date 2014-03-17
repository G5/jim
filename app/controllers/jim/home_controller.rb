class Jim::HomeController < Jim::ApplicationController
  def show
    redirect_to features_path
  end
end
