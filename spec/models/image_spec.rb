require 'spec_helper'

describe Image do

  describe '.batch_build' do
    it 'instantiates N images belonging to product' do
      file = File.new(Rails.root + 'spec/support/test_image.png')
      data = (1..(rand(2) + 1)).map { file }
      product = FactoryGirl.create(:product, store: FactoryGirl.create(:store))
      Image.batch_build(data, product)
      expect { product.save }.to change { product.images.count }.by data.count
    end
  end
end
