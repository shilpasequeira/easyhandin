class InvitesController < ApplicationController
  def create
    if !current_user.teach_courses.include?(Course.find(invite_params[:course_id]))
      notice = "You don't have permissions to do that!!"
    else
      if @invite = Invite.find_by(course_id: invite_params[:course_id], sender_id: current_user.id, email: invite_params[:email])
        InviteMailer.existing_user_invite(@invite).deliver_now
        notice = "Invitation to join as #{@invite.user_role} was resent to #{@invite.email}."
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

          notice = "#{@invite.email} was successfully invited as a #{@invite.user_role}."
        else
          notice = "Could not send an invite to #{@invite.email}"
        end
      end
    end

    redirect_to(course_path(invite_params[:course_id]), :notice => notice)
  end

  private

  def invite_params
    params.require(:invite).permit(:user_role, :email, :university_id, :course_id, :sender_id, :recipient_id, :token)
  end
end
