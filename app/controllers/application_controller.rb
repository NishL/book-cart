class ApplicationController < ActionController::Base
  # We want to check if an administrator is logged in before calling any other actions.
  # We check the session object `session[:user_id]` to see if there is a correspnding user in the
  # database, if there isn't one, then we intercept and send them to the login page.
  # HOWEVER, doing this from the ApplicationController means that all actions, even
  # visiting the store_index_url will require an administrator to be logged in.
  # The `before_action :authorize` gets invoked for every single controller action.
  # We could go through all of the actions and mark only the ones that need authentication,
  # this is called blacklisting, but it can be prone to errors, and it's dangerous for our users
  # if we miss something. A much better approach is to "whitelist" all of the actions that don't
  # need to be authenticated. We will do this by inserting `skip_before_action()` within the StoreController for example.
  # We would also do this within the SessionController,
  before_action :set_i18n_locale_from_params
  before_action :authorize
  protect_from_forgery with: :exception

  protected

  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "Please Log In"
    end
  end

  # Set the locale from the params, but only if there's a locale in the params,
  # otherwise it leaves the current locale alone.
  # We provide a message to both the user and the administrator when a failure occurs.
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.local = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation is not available"
        logger.error flash.now[:notice]
      end
    end
  end
end

# Sending logger messages: http://guides.rubyonrails.org/debugging_rails_applications.html#sending-messages
# Flash messages: http://guides.rubyonrails.org/action_controller_overview.html#the-flash
