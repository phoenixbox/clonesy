class RoleInviteEmailJob
  @queue = :email

  def self.perform(email, current_user, current_store, role)
    Mailer.role_invitation(email, current_user, current_store, role).deliver
  end
end
