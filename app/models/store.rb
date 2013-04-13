class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path
  attr_accessible :status, as: :uber

  before_validation :set_default_status, on: :create

  has_many :categories
  has_many :products
  has_many :user_store_roles

  validates :name, uniqueness: true
  validates :path, uniqueness: true
  validates :status, presence: true,
                     inclusion: { in: %w(online offline pending declined) }

  scope :approved, lambda { where("status <> 'declined'") }

  def is_admin?(user)
    UserStoreRole.exists?(store_id: self, user_id: user, role: :admin)
  end

  def is_stocker?(user)
    UserStoreRole.exists?(store_id: self, user_id: user, role: :stocker)
  end

  def to_param
    path
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def pending?
    self.status == 'pending'
  end

  def toggle_online_status(role)
    if status == 'online'
      update_attributes({status: 'offline'}, as: role)
    elsif status == 'offline'
      update_attributes({status: 'online'}, as: role)
    end
  end

  private

  def set_default_status
    self.status ||= 'pending'
  end
end
