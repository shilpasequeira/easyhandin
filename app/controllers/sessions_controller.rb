class SessionsController < ApplicationController
  skip_before_action :require_login, only: :create

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by(uid: auth["uid"])
    invite_token = params[:invite_token]

    if user.nil? && invite_token.nil? && params[:role] == "student"
      flash[:error] = "You cannot sign up as a student without an invitation."
      redirect_to root_url
      return
    end

    if invite_token.present?
      invite = Invite.find_by_token(invite_token)

      if invite.email != auth["info"]["email"]
        flash[:error] = "Only the Github user with email #{invite.email} can accept this invitation."
        redirect_to root_url
        return
      end
    end

    if user.nil?
      user = User.create_with_omniauth(auth, params[:role])
    end

    session[:user_id] = user.id
    session[:access_token] = auth["credentials"]["token"]

    if invite
      user.complete_invitation(invite)
      flash[:notice] = "Thank you for accepting the invitation to the course #{invite.course.name}"
    end

    redirect_to courses_url
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to root_url
  end
end
