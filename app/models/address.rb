class Address < ActiveRecord::Base
  attr_accessible :street, :state, :zipcode, :city
  belongs_to :user

  validates :street, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :type, presence: true
end
