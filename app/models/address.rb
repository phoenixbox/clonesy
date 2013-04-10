class Address < ActiveRecord::Base
  attr_accessible :street, :state, :zipcode, :city, :type

  belongs_to :addressable, polymorphic: true

  validates :street, presence: true
  validates :state, presence: true, length: 2
  validates :zipcode, presence: true, length: 5
  validates :city, presence: true
  validates :type, presence: true, inclusion: { in: %w(shipping billing) }
end
