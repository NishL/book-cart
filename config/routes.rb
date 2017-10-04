Rails.application.routes.draw do
  root 'store#index', as: 'store_index' # Using `as:` allows the existing tests to continue working. Rails creates `store_index_path` & `store_index_url` accessot methods.

  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
