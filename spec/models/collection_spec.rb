require 'spec_helper'

describe Collection do

  let!(:user){ FactoryGirl.create(:user) }
  let!(:store) {FactoryGirl.create(:store)}
  let!(:product) { FactoryGirl.create(:product, store: store) }
  
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

  context "given a user has added products to an existing collection" do 

    let!(:collection) { Collection.create(name: "a_name", theme: "a_theme", user_id: user.id) }

    before do 
      collection.products << product
    end

    it "generates a random image for the collection for views" do 
      expect(collection.sample_collection_image).to be_kind_of(Paperclip::Attachment)
    end
  end
end
