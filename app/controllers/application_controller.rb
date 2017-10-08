class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :show_time

  def show_time
    @time = Time.now
  end
end
