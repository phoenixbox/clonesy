require 'spec_helper'

describe Collection do
  let!(:user){ FactoryGirl.create(:user) }
  let!(:store) {FactoryGirl.create(:store)}
  let!(:product) { FactoryGirl.create(:product, store: store) }

  subject do
    user.collections.create(name: 'Hotness')
  end

  it "requires a name" do
    expect { subject.name = '' }.to change { subject.valid? }.to(false)
  end


  it "requires a user" do
    expect { subject.user = nil }.to change { subject.valid? }.to(false)
  end

  context "given a user has added products to an existing collection" do 

    let!(:collection) { Collection.create(name: "a_name", user: user) }

    before do 
      collection.products << product
    end

    it "generates a random image for the collection for views" do 
      expect(collection.sample_collection_image).to be_kind_of(Paperclip::Attachment)
    end
  end
end
