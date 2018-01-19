class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    user = User.find_by(params[:name]) # This may be vulnerable to SQL injection
    @user_name = user.name
  end
end
