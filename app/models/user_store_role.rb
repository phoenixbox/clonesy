class UserStoreRole < ActiveRecord::Base
  belongs_to :store_id
  belongs_to :user_id
  attr_accessible :role, :user_id, :store_id

  def self.current_store
    store_id
  end
end
