Rails.application.routes.draw do
  root "shop#index"

  resources :shop, :products, :product_types, :discounts, :cart

  get 'remove_product_from_cart' => 'cart#remove_product_from_cart'
end
