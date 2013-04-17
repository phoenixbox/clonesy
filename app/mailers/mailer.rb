class Mailer < ActionMailer::Base
  add_template_helper(MailerHelper)
  default from: "white@mrwhite-sose.herokuapp.com"

  def welcome_email(email, full_name)
    @full_name = full_name
    mail(to: email, subject: "Welcome to White's Monsterporium!")
  end

  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(to: user.email, subject: "Thanks for your purchase!")
  end

  def role_confirmation(user, store, role)
    @user = user
    @role = role
    @store = store
    mail(to: user.email, subject: "You're now a #{role}!")
  end

  def role_invitation(email, inviter, store, role)
    @inviter = inviter
    @store = store
    @role = role
    mail(to: email, subject: "You've been invited!")
  end

  def revoke_role(user, store)
    @user = user
    @store = store
    mail(to: user.email, subject: "Role revoked")
  end
end
