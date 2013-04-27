class Product < ActiveRecord::Base
  attr_accessible :title,
                  :description,
                  :price,
                  :status,
                  :category_ids,
                  :categories,
                  :store_id

  has_and_belongs_to_many :categories
  belongs_to :store
  has_many :images
  # , validate: true, autosave: true

  # accepts_nested_attributes_for :images
  # attr_accessible :image

  validates :title, presence: :true,
                    uniqueness: { case_sensitive: false }
  validates :description, presence: :true
  validates :status, presence: :true,
                     inclusion: { in: %w(active retired) }
  validates :price, presence: :true,
                    format: { with: /^\d+??(?:\.\d{0,2})?$/ },
                    numericality: { greater_than: 0 }
  validates :store_id, presence: true

  scope :active, lambda { where(status: 'active') }

  def self.by_category(category_id)
    if category_id.present?
      Category.find(category_id).products
    else
      scoped
    end
  end

  def toggle_status
    if status == 'active'
      update_attributes(status: 'retired')
    elsif status == 'retired'
      update_attributes(status: 'active')
    end
  end

  def self.featured
    if Store.count > 0
      store_id = rand(Store.count) + 1
      store = Store.find(store_id)
      store.products.includes(:store).limit(4)
    else
      []
    end
  end

  def self.recent
    if Product.count > 0
      Product.includes(:store).order("created_at DESC").limit(6)
    else
      []
    end
  end

end
