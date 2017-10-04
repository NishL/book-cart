class StoreController < ApplicationController
  def index
    # The customer wants titles displayed in alphabetical order.
    # Achieve this by calling `order(:title)` on the  `Product` model.
    @products = Product.order(:title)
  end
end
