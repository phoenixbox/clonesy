require 'spec_helper'

describe Collection do

  let!(:user){ FactoryGirl.create(:user) }
  
  it "validates presence of collection name" do
    Collection.create(theme: "a_theme", user_id: user.id)
    expect(Collection.count).to eq 0
  end

  it "validates presence of collection theme" do 
    Collection.create(name: 'collection', user_id: user.id)
    expect(Collection.count).to eq 0
  end

  it "validates presence of collection's user" do
    Collection.create(name: "a_name", theme: "a_theme")
    expect(Collection.count).to eq 0 
  end

end
