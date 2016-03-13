class InvitesController < ApplicationController
  def create
    if @invite = Invite.find_by(course_id: invite_params[:course_id], sender_id: current_user.id, email: invite_params[:email])
      InviteMailer.existing_user_invite(@invite).deliver_now
      notice = "Invitation to join as #{@invite.user_role} was resent to #{@invite.email}."
    else
      @invite = Invite.new(invite_params)
      @invite.sender_id = current_user.id

      if @invite.save
        if @invite.recipient != nil   
          @invite.recipient.add_to_course(@invite.course)
          InviteMailer.existing_user_invite(@invite).deliver_now
        else
          InviteMailer.new_user_invite(@invite, signin_link(role: @invite.user_role, invite_token: @invite.token)).deliver_now
        end

        notice = "#{@invite.email} was successfully invited as a #{@invite.user_role}."
      else
        notice = "Could not send an invite to #{@invite.email}"
      end
    end

    redirect_to(course_path(@invite.course), :notice => notice)
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def invite_params
    params.require(:invite).permit(:user_role, :email, :course_id, :sender_id, :recipient_id, :token)
  end
end
