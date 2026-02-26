Rails.application.routes.draw do
  get 'top/index'
  root "top#index"

  get "solo", to: "boards#show", as: :solo
  get "how_to_play", to: "top#how_to_play", as: :how_to_play

  post "mark", to: "boards#mark", as: :mark
  post "reset", to: "boards#reset"
  get "result", to: "boards#result"

  resources :rooms, only: [:create, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
