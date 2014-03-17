Jim::Engine.routes.draw do
  resources :features, only: :index

  root to: "home#show"
end
