FactoryGirl.define do

  sequence :name do |n|
    "unique_store_#{n}"
  end

  sequence :title do |n|
    "unique_title_#{n}"
  end

  sequence :path do |n|
    "unique_store_#{n}"
  end

  factory :category do
    title 'Dark Matter'
  end

  factory :order_item do
    unit_price 20.00
    quantity 3
  end

  factory :order do
    status 'pending'
  end

  factory :product do
    categories { [FactoryGirl.build(:category)] }
    title
    description 'Hurts so good'
    price 12.99
    status 'active'
  end

  factory :user do
    full_name 'Raphael Weiner'
    email 'raphael@example.com'
    display_name 'raphweiner'
    password 'password'

    factory :invalid_user do
      full_name nil
    end
  end

  factory :address do
    street  '43 Logan Street'
    state   'CA'
    zipcode '90100'
    city    'The Angels'
  end

  factory :store do
    name
    description   'The bestest store'
    path
    status 'online'
  end
end
