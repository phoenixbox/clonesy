class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path
  attr_accessible :status, as: :uber

  has_many :categories
  has_many :products
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
    self.count > 0 ? self.online.last : nil
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

  def orders
    Order.find_by_sql("SELECT orders.* from orders INNER JOIN order_items on order_items.order_id = orders.id INNER JOIN products on products.id = order_items.product_id where products.store_id = #{id} order by orders.created_at DESC")
  end

  def orders_by_status(order_status=nil)
    results = if order_status && order_status != 'all'
      orders.select { |order| order.status == order_status }
    else
      orders
    end
    results.uniq
  end

private
  def parameterize_path
    self.path = path.parameterize
  end
end
