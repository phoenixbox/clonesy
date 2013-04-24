class UserStoreRole < ActiveRecord::Base
  attr_accessible :store_id, :user_id, :role, as: :uber

  belongs_to :store
  belongs_to :user

  validates :role, presence: true,
                   inclusion: {in: %w(admin) }

  validates :store_id, presence: true
  validates :user_id, presence: true
end
