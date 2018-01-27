class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    user = User.find(session[:user_id]) # No longer vulnerable to SQL injection, because we find the user from the session object.
    @user_name = user.name
  end
end
