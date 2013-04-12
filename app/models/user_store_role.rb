class UserStoreRole < ActiveRecord::Base
  belongs_to :store_id
  belongs_to :user_id

  validates :role, presence: true,
                   inclusion: {in: %w(admin stocker) }

  validates :store_id, presence: true
  validates :user_id, presence: true

  def admin?
    self.role == 'admin'
  end

  def stocker?
    self.role == 'stocker'
  end
end
