class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.create_with_omniauth(auth, request.params[:role])
    session[:user_id] = user.id
    session[:access_token] = auth["credentials"]["token"]
    redirect_to "/courses"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
