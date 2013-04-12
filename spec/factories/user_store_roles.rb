# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_store_role do
    store_id nil
    user_id nil
    role "MyString"
  end
end
