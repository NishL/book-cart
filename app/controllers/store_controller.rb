class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart # We're invoking the store index() action which needs to set @cart now, as soon as the user vists we'll create a cart. 
  def index
    # The customer wants titles displayed in alphabetical order.
    # Achieve this by calling `order(:title)` on the  `Product` model.
    @products = Product.order(:title)
  end
end
