class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize # We need a cart to be added to the session upon app visit without authentication.
  before_action :set_cart # We're invoking the store index() action which needs to set @cart now, as soon as the user vists we'll create a cart, but only for the cart & store controllers.
  def index
    # The customer wants titles displayed in alphabetical order.
    # Achieve this by calling `order(:title)` on the  `Product` model.
    # @products = Product.order(:title)
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
    end
  end
end
