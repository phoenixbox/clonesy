class RoleConfirmationEmailJob
  @queue = :email

  def self.perform(user, store, role)
    Mailer.role_confirmation(user, current_store, role).deliver
  end

end
