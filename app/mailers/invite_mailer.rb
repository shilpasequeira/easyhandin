class InviteMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def existing_user_invite(invite)
    @invite = invite
    mail(to: invite.email, subject: "You have been added to course #{invite.course.name}")
  end

  def new_user_invite(invite, invite_link)
    @invite = invite
    @invite_link = invite_link
    mail(to: invite.email, subject: "You have been invited to course #{invite.course.name}")
  end
end
