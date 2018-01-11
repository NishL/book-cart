class SessionController < ApplicationController
  def new
  end

  def create
    # We need to record something in the session to show that an administrator is logged in.
    # We will store the ID of that person's `User` object using the the key `:user_id` in the session hash.
    user = User.find_by(name: params[:name]) # The user enters their username in the form
    if user&.authenticate(params[:password]) # If the username is found then try to authenticate their password.
      session[:user_id] = user.id # If the username was found and the password matches, then add :user_id to the session object.
      redirect_to admin_url # After authenication redirect to the admin_url page.
    else
      redirect_to login_url, alert: 'Invalid user/password combination'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to store_index_url, notice: "Logged out"
  end
end

# How the create() action works:
# 1) First, find the user by their name when it's passed in through the accepted params for a User object. Save it in a variable.
# 2) Use the Rails try() method to check if a variable has a value of `nil` before trying to call the method.
#    -change to `user&.authenticate(params[:password])`, this is in the Ruby core instead of Rails ActiveSupport,
#     it's called the "safe travaersal" or "safe navigation" operator, it checks if an object is nil (user in this case) and returns `nil`
#     instead of a "NoMethodError: undefined method `authenticate' for nil:NilClass"
# 3) If the user is authenticated then store the user ID in the session object and redirect them to the admin page.
# 4) If the user is not authenticated then redirect them to the login page again.
