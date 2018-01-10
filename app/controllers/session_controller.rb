class SessionController < ApplicationController
  def new
  end

  def create
    # We need to record something in the session to show that an administrator is logged in.
    # We will store the ID of that person's `User` object using the the key `:user_id` in the session hash.
    user = User.find_by(name: params[:name]) # The user enters their username in the form
    if user.try(:authenticate, params[:password]) # If the username is found then try to authenticate their password
      session[:user_id] = user.id # If the username was found and the password matches, then add :user_id to the session object.
      redirect_to admin_url # After authenication redirect to the admin_url page.
    else
      redirect_to login_url, alert: 'Invalid user/password combination'
    end
  end

  def destroy
  end
end
