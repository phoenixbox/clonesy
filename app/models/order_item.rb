class OrderItem < ActiveRecord::Base
  attr_accessible :product_id, :quantity, :unit_price
  belongs_to :order
  belongs_to :product
  delegate :title, :store, to: :product

  validates :unit_price, presence: :true,
                         format: { with: /^\d+??(?:\.\d{0,2})?$/ },
                         numericality: { greater_than: 0 }

  validates :quantity, presence: :true,
                       numericality: { greater_than: 0, only_integer: true }

  validates :product, presence: true
  validates :order, presence: true

  def subtotal
    BigDecimal.new(unit_price.to_s) * BigDecimal.new(quantity.to_s)
  end
end
