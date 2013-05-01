class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path
  attr_accessible :status, as: :uber

  has_many :categories
  has_many :products
  has_many :orders
  has_many :user_store_roles

  before_validation :parameterize_path

  validates :name, presence: true,
                   uniqueness: true

  validates :path, presence: true,
                   uniqueness: true

  validates :status, presence: true,
                     inclusion: { in: %w(online offline pending declined) }

  scope :approved, lambda { where("status <> 'declined'") }

  scope :online, lambda { where(status: 'online') }

  def self.popular
    popular_store = LocalStore.popular_store
    find(popular_store) if popular_store
  end

  def self.recent
    self.count > 0 ? self.last : nil
  end

  def is_admin?(user)
    user.uber? || UserStoreRole.exists?(store_id: self,
                                        user_id: user,
                                        role: :admin)
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
    next_status = {'online' => 'offline', 'offline' => 'online'}[status]
    update_attributes({status: next_status}, as: role) if next_status
  end

  def increase_popularity(user)
    LocalStore.increase_popularity('store', id, user)
  end

private
  def parameterize_path
    self.path = path.parameterize
  end
end
