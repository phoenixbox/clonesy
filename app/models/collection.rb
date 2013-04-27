class Collection < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :theme, :user_id

  validates_presence_of :name, :theme, :user_id
end
