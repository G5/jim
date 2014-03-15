Jim::Engine.routes.draw do
  resources :features, only: :index

  root to: redirect(Jim::Engine.routes.url_helpers.features_path)
end
