class SessionsController < ApplicationController
  skip_before_action :require_login, only: :create

  def create
    auth = request.env["omniauth.auth"]
    user = User.create_with_omniauth(auth, request.params[:role])
    session[:user_id] = user.id
    session[:access_token] = auth["credentials"]["token"]

    if token = request.params[:invite_token]
      user.complete_invitation(Invite.find_by_token(token))
    end

    hash1 = { :username => "lexman34", :repo => "EA_Repo1" }
    hash2 = { :username => "shilpasequeira", :repo => "EA_Repo2"}
    
    username_repos = []
    username_repos.push(hash1)
    username_repos.push(hash2)

    PublishCourse.perform(session[:access_token], "CPEN-221", username_repos)

    redirect_to dashboard_url
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_url
  end
end
