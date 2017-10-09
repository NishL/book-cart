module CurrentCart

  private

  # Rails make the current session look like a hash to the controller,
  # so we'll store the ID of the cart in the session by indexing it with the
  # `:cart_id` symbol.
  def set_cart
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

end

# How the `set_cart()` method works:
#
# 1) The method starts by getting the `:cart_id` from the `session` object and
# => then attempts to find a cart corresponding to this ID.
#
# 2) If such a cart record isn't found then an `ActiveRecord::RecordNotFound`
# => error is raised (which will happen if the ID is `nil` or invalid for any
# => reason). It's rescued and proceeds by creating a new `Cart` and then stores
# => the ID of the created cart in the session.

# Note:
# By placing files in the 'concerns' directory we are able to share common code
# among all controllers. Additionally, the method is marked as 'private', preventing
# it from being used as an action in the controller.

# References:
# 1) `ActiveRecord::RecordNotFound` http://api.rubyonrails.org/v5.0.5/classes/ActiveRecord/RecordNotFound.html
# 2) Why we created this file in concerns:
# => https://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns
# Read about sessions: http://guides.rubyonrails.org/security.html#sessions
