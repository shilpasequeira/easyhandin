class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    pry
    user = User.create_with_omniauth(auth, request.params[:role])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
