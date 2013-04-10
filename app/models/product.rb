class Product < ActiveRecord::Base
  attr_accessible :title, :description, :price, :status, :category_ids, :image
  has_and_belongs_to_many :categories

  has_attached_file :image, styles: { retail: "500x500",
                                      large: "500x500",
                                      thumbnail: "200x200" },
                            storage: :s3,
                            bucket: 'c3po_store_engine',
                            path: ":attachment/:id/:style.:extension",
                            s3_credentials: {
                              access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                              secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                              }

  validates :title, presence: :true,
                    uniqueness: { case_sensitive: false }
  validates :description, presence: :true
  validates :status, presence: :true,
                     inclusion: { in: %w(active retired) }
  validates :price, presence: :true,
                    format: { with: /^\d+??(?:\.\d{0,2})?$/ },
                    numericality: { greater_than: 0 }

  def toggle_status
    if status == 'active'
      update_attributes(status: 'retired')
    elsif status == 'retired'
      update_attributes(status: 'active')
    end
  end
end
