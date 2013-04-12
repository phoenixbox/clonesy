class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path, :status

  before_create :default_status 

  has_many :categories
  has_many :products

  validates :name, :uniqueness => true
  validates :path, :uniqueness => true
  # validates(:status, {inclusion: { in: ['online', 'offline', 'pending', 'declined'] }, presence: true})

  def to_param
    path
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def pending?
    self.status == 'pending'
  end

private
  
  def default_status
    self.status = "pending"
  end


  # def status
  #   self.status
  # end
end
