require 'spec_helper'

describe Product do
  before (:each) do
    @store = FactoryGirl.create(:store)
  end

  subject do
    Product.new(
      title: 'Salty Trout',
      description: 'Yummy',
      status: 'active',
      price: 2.00,
      store_id: @store.id)
  end

  it 'has a valid subject' do
    expect(subject).to be_valid
  end

  it 'requires a title' do
    expect { subject.title = '' }.to change { subject.valid? }.to(false)
  end

  it 'requires a description' do
    expect { subject.description = '' }.to change { subject.valid? }.to(false)
  end

  it 'requires a unique title (case insensitive)' do
    subject.save
    store = FactoryGirl.build(:product, title: 'salty trout', store: @store)
    expect(store).to_not be_valid
  end

  it 'requires a price' do
    expect { subject.price = nil }.to change { subject.valid? }.to(false)
  end

  it 'requires a price greater than 0' do
    expect { subject.price = 0 }.to change { subject.valid? }.to(false)
  end

  it 'requires two or less decimal points' do
    expect { subject.price = 0.123 }.to change { subject.valid? }.to(false)
    expect { subject.price = 0.10 }.to change { subject.valid? }.to(true)
    expect { subject.price = 0.1 }.to_not change { subject.valid? }
    expect { subject.price = 2 }.to_not change { subject.valid? }
  end

  it 'requires a status' do
    expect { subject.status = '' }.to change { subject.valid? }.to(false)
  end

  it 'requires a valid status' do
    expect { subject.status = 'retired' }.to_not change { subject.valid? }
    expect { subject.status = 'abc' }.to change { subject.valid? }.to(false)
  end

  it 'has the ability to be assigned to multiple categories' do
    nicknacks = FactoryGirl.create(:category, title: 'nicknacks')
    superheroes = FactoryGirl.create(:category, title: 'superheroes')

    subject.categories = [nicknacks, superheroes]
    subject.save

    expect(subject.categories.count).to eq 2
  end

  it 'deletes associated images upon destroy' do
    subject.images.build(data: File.new(Rails.root + 'spec/support/test_image.png'))
    subject.save

    expect { subject.destroy }.to change { Image.count }.by -1
  end

  describe '#img' do
    it 'returns an object that responds to #url with or without an associated image' do
      subject.images.build(data: File.new(Rails.root + 'spec/support/test_image.png'))
      subject.save

      expect { subject.images.destroy }.to_not change { subject.img.respond_to?(:url) }.to false
    end
  end

  describe '#update_attributes_with_images' do
    it 'updates product attributes' do
      image = mock('Fake Image', :images => true)
      subject.update_attributes_with_images({title: 'Neutral Eagle'})
      expect(subject.title).to eq 'Neutral Eagle'
    end
  end

  describe '.popular' do
    it 'delegates to LocalStore and returns products' do
      products = (1..2).map { FactoryGirl.create(:product, store: @store) }
      LocalStore.stub(:popular_products).and_return(products.map(&:id))
      expect(Product.popular).to match_array products
    end
  end

  describe '.recent' do
    it 'assigns the six most recent products from all stores' do
      products = (1..7).map { FactoryGirl.create(:product, store: @store) }
      expect((Product.recent & products).count).to eq 6
    end
  end

  describe '.toggle_status' do
    it 'toggles status from active to retired and back' do
      expect { subject.toggle_status }.to change { subject.status }.to('retired')
      expect { subject.toggle_status }.to change { subject.status }.to('active')
    end
  end

  describe '.category id' do
    context "with a category_id" do
      it "finds the products by the category_id" do
        nicknacks = FactoryGirl.create(:category, title: 'nicknacks')
        product1 = FactoryGirl.create(:product, store: @store, categories: [nicknacks] )
        product2 = FactoryGirl.create(:product, store: @store, categories: [nicknacks] )
        product3 = FactoryGirl.create(:product, store: @store)
        expect(Product.by_category(nicknacks.id)).to eq [product1, product2]
      end
    end

    context "without a category_id" do
      it "doesn't apply a category filter" do
        products = (1..3).map { FactoryGirl.create(:product, store: @store) }
        expect(Product.by_category(nil)).to match_array products
      end
    end
  end

  describe '.new_with_images' do
    context 'with one image and valid product attributes' do
      it 'instantiates a new product with images' do
        params = {title: 'Bitter Cod',
                  description: 'Yummy',
                  status: 'active',
                  price: 2.00,
                  store_id: @store.id,
                  images: {key: 1} }
        Image.stub(:new).and_return(Image.new)
        product = Product.new_with_images(params)
        expect(product.images.length).to eq 1
      end
    end
  end
end
