class Collection < ActiveRecord::Base
  belongs_to :user

  has_many :collection_products
  has_many :products, through: :collection_products

  attr_accessible :name, :theme, :user_id

  validates_presence_of :name, :theme, :user_id

  def add_product(product_id)
    product = Product.find(product_id)
    self.products << product
  end
end
