class InvitesController < ApplicationController
  before_action :check_user_is_instructor

  def create
    if !current_user.teach_courses.include?(Course.find(invite_params[:course_id]))
      flash[:warning] = "You don't have permissions to do that!!"
    else
      if @invite = Invite.find_by(course_id: invite_params[:course_id], sender_id: current_user.id, email: invite_params[:email])
        InviteMailer.existing_user_invite(@invite).deliver_now
        flash.notice = "Invitation to join as #{@invite.user_role} was resent to #{@invite.email}."
      else
        @invite = Invite.new(invite_params)
        @invite.sender_id = current_user.id

        if @invite.save
          if @invite.recipient != nil
            @invite.recipient.complete_invitation(@invite)
            InviteMailer.existing_user_invite(@invite).deliver_now
          else
            InviteMailer.new_user_invite(@invite, signin_link(role: @invite.user_role, invite_token: @invite.token)).deliver_now
          end

          flash[:notice] = "#{@invite.email} was successfully invited as a #{@invite.user_role}."
        else
          flash[:error] = "Could not send an invite to #{@invite.email}"
        end
      end
    end

    if invite_params[:user_role] == "student"
      redirect_to students_path(invite_params[:course_id])
    elsif invite_params[:user_role] == "instructor"
      redirect_to instructors_path(invite_params[:course_id])
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:user_role, :name, :email, :university_id, :course_id, :sender_id, :recipient_id, :token)
  end
end
