class Order < ActiveRecord::Base
  attr_accessible :status, :user_id, :store_id
  belongs_to :user
  belongs_to :store
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :billing_address, as: :addressable
  has_one :shipping_address, as: :addressable
  validates :user_id, presence: true
  validates :status, presence: true,
                    inclusion: {in: %w(pending cancelled paid shipped returned),
                                  message: "%{value} is not a valid status" }

  def self.by_status(status)
    if status.present? && status != 'all'
      order.where(status: status)
    else
      scoped
    end
  end

  def self.create_pending_order(user, cart_items)
    transaction do
      create(status: 'pending', user_id: user.id).tap do |order|
        cart_items.each do |cart_item|
          order.order_items.create(product_id: cart_item.product.id,
                                   unit_price: cart_item.unit_price,
                                   quantity: cart_item.quantity)
        end
      end
    end
  end

  def update_status
    next_status = { 'pending' => 'cancelled',
                    'paid' => 'shipped',
                    'shipped' => 'returned' }
    self.status = next_status[self.status]
    self.save
  end

  def total
    if order_items.present?
      order_items.map {|order_item| order_item.subtotal }.inject(&:+)
    else
      0
    end
  end
end
