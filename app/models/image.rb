class Image < ActiveRecord::Base
  attr_accessible :photo,
                  :product

  belongs_to :product

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end