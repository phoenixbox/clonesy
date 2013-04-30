require 'spec_helper'

describe 'the user cart view' do
  before(:each) do
    @store = FactoryGirl.create(:store)
    LocalStore.stub(:increase_popularity).and_return(true)
  end

  context 'when there are no items in the cart' do
    it 'displays a message that the cart is empty' do
      visit cart_path
      expect(page).to have_content('empty')
    end
  end

  context 'when there are items in the cart' do
    before(:each) do
      @product = FactoryGirl.create(:product, store: @store)
      visit store_product_path(@store, @product)
      click_button 'Add to Cart'
      visit cart_path
    end

    it 'shows the cart with items quantities and prices' do
      expect(page).to have_content('Total')
    end

    context 'the user wants to empty the cart' do
      it 'gets emptied' do
        visit store_product_path(@store, @product)
        click_button 'Add to Cart'
        visit cart_path
        click_link 'Remove'
        expect(page).to have_content('Your cart is empty')
      end
    end

    context 'the user wants to remove an item from the cart' do
      it 'gets removed' do
        click_button 'Empty Cart'
        expect(current_path).to eq root_path
      end
    end

    context 'the user wants to remove an item from the cart' do
      it 'removes an item' do
        visit cart_path
        fill_in 'carts_quantity', with: '0'
        click_button 'Update'
        expect(find("input#carts_quantity").value).to eq '0'
      end
    end
  end
end
