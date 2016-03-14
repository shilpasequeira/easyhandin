# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview
  def existing_user_invite_preview
    InviteMailer.existing_user_invite(Invite.first)
  end

  def new_user_invite_preview
    InviteMailer.new_user_invite(Invite.first)
  end
end
