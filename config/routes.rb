Jim::Engine.routes.draw do
  resources :features, only: :index
end
