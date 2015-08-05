Rails.application.routes.draw do
  root "shop#index"

  resources :shop, :products, :product_types, :discounts, :cart
end
