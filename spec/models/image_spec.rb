require 'spec_helper'

describe Image do
  subject do
    File.new(Rails.root + 'spec/support/test_image.png')
  end

  describe '.batch_create' do
    it 'creates N images belonging to product' do
      data = (1..(rand(2) + 1)).map { subject }
      product = FactoryGirl.create(:product, store: FactoryGirl.create(:store))
      expect { Image.batch_create(data, product) }.to change { product.images.count }.by data.count
    end
  end
end
