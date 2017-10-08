class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :show_time # Use a `before` filter to run code before a controller action

  # Make the `@time` variable available to all views
  def show_time
    @time = Time.now
  end
end

# http://guides.rubyonrails.org/action_controller_overview.html
