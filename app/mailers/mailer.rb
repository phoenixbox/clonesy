class Mailer < ActionMailer::Base
  default from: "frank@franks-monsterporium.com"

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Frank's Monsterporium!")
  end

  def order_confirmation(user, order)
    @user = user
    @order = order
    mail(to: user.email, subject: "Thanks for your purchase!")
  end

  def stocker_confirmation(user, store)
    @user = user
    @store = store
    mail(to: user.email, subject: "You're now a stocker!")
  end

  def stocker_invitation(email, inviter, store)
    @store = store
    @inviter = inviter
    mail(to: email, subject: "You've been invited!")
  end
end
