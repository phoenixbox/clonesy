class Role
  def self.promote(user, store, role)
    existing_relationship = UserStoreRole.where(user_id: user.id,
                                                store_id: store.id).first

    if existing_relationship.present?
      existing_relationship.update_attributes({role: role}, as: :uber)
    else
      UserStoreRole.create!({user_id: user.id,
                             store_id: store.id,
                             role: role}, as: :uber)
    end
  end

  def self.revoke(user_id, store)
    relationship = UserStoreRole.where(user_id: user_id,
                                       store_id: store.id).first
    relationship.destroy
  end
end
