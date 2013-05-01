require 'spec_helper'

describe LocalStore do

  describe "#increase_popularity" do 

    let!(:store) { FactoryGirl.create(:store) }

    context "given a user is not unique" do 

      before do 
        LocalStore.stub(:user_has_already_visited?).and_return(true)
      end

      it "does not increase the store's popularity" do 
        LocalStore.should_not_receive(:update_popularity).with('store', store.id)
      end
    end

    context "given a user is unique" do 

      before do 
        LocalStore.stub(:user_has_already_visited?).and_return(false)
        LocalStore.stub(:add_visitor).and_return(true)
      end

      it "increases the store's popularity" do 
        pending "Getting help with this in class"
        LocalStore.should_receive(:update_popularity).with('store', store.id)
      end
    end
  end
end
