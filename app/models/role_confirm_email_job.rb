class RoleConfirmEmailJob
  @queue = :email

  def self.perform(user, current_store, role)
    Mailer.role_confirmation(user, current_store, role).deliver
  end

end
