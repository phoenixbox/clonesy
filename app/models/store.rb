class Store < ActiveRecord::Base
  attr_accessible :description, :name, :path, :theme
  attr_accessible :status, as: :uber

  has_many :categories
  has_many :products
  has_many :user_store_roles

  before_validation :parameterize_path

  validates :name, presence: true,
                   uniqueness: true

  validates :path, presence: true,
                   uniqueness: true

  validates :status, presence: true,
                     inclusion: { in: %w(online offline pending declined) }

  validates :theme, presence: true,
                    inclusion: { in: %w(default wood soft mocha scale escheresque metal) }

  scope :approved, lambda { where("status <> 'declined'") }

  scope :online, lambda { where(status: 'online') }

  def is_admin?(user)
    user.uber? || UserStoreRole.exists?(store_id: self,
                                        user_id: user,
                                        role: :admin)
  end

  def self.themes
    %w(default wood soft mocha scale escheresque metal)
  end

  def is_stocker?(user)
    UserStoreRole.exists?(store_id: self,
                          user_id: user,
                          role: :stocker)
  end

  def admin_or_stocker?(user)
    if is_admin?(user)
      :admin
    elsif is_stocker?(user)
      :stocker
    end
  end

  def to_param
    path
  end

  def not_found
    raise ActionController::RoutingError.new('Not found')
  end

  def pending?
    self.status == 'pending'
  end

  def toggle_online_status(role)
    if status == 'online'
      update_attributes({status: 'offline'}, as: role)
    elsif status == 'offline'
      update_attributes({status: 'online'}, as: role)
    end
  end

  private

  def parameterize_path
    self.path = path.parameterize
  end
end
