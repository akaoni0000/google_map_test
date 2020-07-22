Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#top"
  post "create" => "home#create", as: "hotels"
end
