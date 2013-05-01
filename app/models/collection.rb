class Collection < ActiveRecord::Base
  attr_accessible :name,
                  :user

  belongs_to :user
  has_and_belongs_to_many :products

  validates :name, presence: true
  validates :user, presence: true

  scope :for_user, lambda { |user| where(user_id: user) if user }

  def add_product(product_id)
    product = Product.find(product_id)
    self.products << product unless products.include?(product)
  end

  def remove_product(product_id)
    product = Product.find(product_id)
    self.products.destroy(product)
  end

  def sample_collection_image
    self.products.sample.img if (!self.products.empty?)
  end

  def sample_products
    self.products.limit(2)
  end
end
