class Collection < ActiveRecord::Base
  belongs_to :user

 
  has_and_belongs_to_many :products

  attr_accessible :name, :theme, :user_id

  validates_presence_of :name, :theme, :user_id

  def add_product(product_id)
    product = Product.find(product_id)
    self.products << product
  end

  def remove_product(product_id)
    product = Product.find(product_id)
    self.products.destroy(product)
  end

end
