class Category < ActiveRecord::Base
  attr_accessible :title, :product_ids, :store_id
  has_and_belongs_to_many :products

  validates :title, presence: true,
                    uniqueness: {case_sensitive: false}
  # validates :uniqueness

  
end
