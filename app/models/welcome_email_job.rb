class  WelcomeEmailJob
  @queue = :email

  def self.perform(email, full_name)
    Mailer.welcome_email(email, full_name).deliver
  end

end