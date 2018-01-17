Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :session do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :orders
  resources :line_items
  resources :carts

  resources :products do
    get :who_bought, on: :member # Try it out: `curl --silent http://localhost:3000/products/3/who_bought.atom`
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
    #root 'store#index', as: 'store_index' # Using `as:` allows the existing tests to continue working. Rails creates `store_index_path` & `store_index_url` accessor methods.
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
