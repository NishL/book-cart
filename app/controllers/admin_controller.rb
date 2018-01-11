class AdminController < ApplicationController
  def index
    @total_orders = Order.count
    user_name = User.find_by(params[:name])
    @user = user_name.name
  end
end
