class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path, :status

  before_create :default_status

  has_many :categories
  has_many :products
  has_many :user_store_roles
  has_many :users, through: :user_store_roles

  validates :name, uniqueness: true
  validates :path, uniqueness: true
  validates :status, presence: true,
                     inclusion: { in: %w(online offline pending disapproved) }

  def to_param
    path
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def pending?
    self.status == 'pending'
  end

  def toggle_status
    if status == 'online'
      update_attributes(status: 'offline')
    elsif status == 'offline'
      update_attributes(status: 'online')
    end
  end

private

  def default_status
    self.status = "pending"
  end

  # def status
  #   self.status
  # end
end
