class Mailer < ActionMailer::Base
  default from: "steve@dose-jobs.herokuapp.com"

  def welcome_email(email, full_name)
    @full_name = full_name
    mail(to: email, subject: "Welcome to Job's DOSE!")
  end

  def order_confirmation(user, order_id, order_total)
    @user = user
    @order_id = order_id
    @order_total = order_total
    mail(to: user["email"], subject: "Thanks for your purchase!")
  end

  def role_confirmation(user, current_store, role)
    @user = user
    @role = role
    @store = current_store
    mail(to: user["email"], subject: "You're now a #{role}!")
  end

  def role_invitation(email, current_user, current_store, role)
    @inviter = current_user
    @store = current_store
    @role = role
    mail(to: email, subject: "You've been invited!")
  end

  def revoke_role(user, store)
    @user = user
    @store = store
    mail(to: user["email"], subject: "Role revoked")
  end
end
