Rails.application.routes.draw do
  root "boards#show"
  post "mark", to: "boards#mark", as: :mark
  post "reset", to: "boards#reset"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
