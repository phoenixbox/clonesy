class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :display_name,
                  :email,
                  :full_name,
                  :password,
                  :password_confirmation,
                  :orphan

  has_one :billing_address, validate: true, autosave: true
  has_one :shipping_address, validate: true, autosave: true
  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address
  attr_accessible :billing_address_attributes,
                  :shipping_address_attributes

  validates_confirmation_of :password,
                            message: "passwords did not match", if: :password
  validates_presence_of :password, on: :create

  validates :full_name, presence: :true
  validates :email, presence: :true, uniqueness: :true,
            format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }
  validates :display_name, length: { in: 2..32 }, allow_blank: :true

  has_many :orders
  has_many :user_store_roles
  has_many :stores, through: :user_store_roles

  def self.new_guest(params=nil)
    params ||= {}
    params[:full_name] = "Guest"
    params[:password] = generate_password
    params[:password_confirmation] = params[:password]
    params[:orphan] = true

    new(params)
  end

  def uber_up
    self.uber = true
    self.save
  end

  def uber?
    self.uber
  end

  def orphan?
    self.orphan
  end

  private

  def self.generate_password
    o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...50).map{ o[rand(o.length)] }.join
  end
end
