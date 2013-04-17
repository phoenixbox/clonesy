class RoleRevokeEmailJob
  @queue = :email

  def self.perform(user, current_store)
    Mailer.revoke_role(user, current_store).deliver
  end

end
