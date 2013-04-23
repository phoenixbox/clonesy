require 'spec_helper'

describe Role do
  describe 'self.promote' do
    it 'promotes user to said role for store' do
      store = FactoryGirl.create(:store)
      user = FactoryGirl.create(:user)

      expect(store.is_admin?(user)).to eq false
      Role.promote(user, store, 'admin')
      expect(store.is_admin?(user)).to eq true
    end

    it 'updates role if user role already exists in table for store' do
      store = FactoryGirl.create(:store)
      user = FactoryGirl.create(:user)
      Role.promote(user, store, 'admin')

      expect(store.is_admin?(user)).to eq true
      Role.promote(user, store, 'admin')
      expect(store.is_admin?(user)).to eq true
    end
  end

  describe 'self.revoke' do
    it 'revokes user role for store' do
      store = FactoryGirl.create(:store)
      user = FactoryGirl.create(:user)
      Role.promote(user, store, 'admin')

      expect(store.is_admin?(user)).to eq true
      Role.revoke(user.id, store)
      expect(store.is_admin?(user)).to eq false
    end

    it 'does nothing if role for user and store does not exist' do
      store = FactoryGirl.create(:store)
      user = FactoryGirl.create(:user)

      expect(store.is_admin?(user)).to eq false
      Role.revoke(user.id, store)
      expect(store.is_admin?(user)).to eq false
    end
  end
end
