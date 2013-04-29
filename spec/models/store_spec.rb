require 'spec_helper'

describe Store do
  subject do
    Store.new(
      name: 'Petals, Purses and Pastries',
      path: 'petals-purses-and-pastries')
  end

  it 'requires a name' do
    expect { subject.name = '' }.to change{ subject.valid? }.to(false)
  end

  it 'requires a unique name' do
    subject.save
    store = FactoryGirl.build(:store, name: 'Petals, Purses and Pastries')
    expect(store).to_not be_valid
  end

  it 'requires a path' do
    expect { subject.path = '' }.to change{ subject.valid? }.to(false)
  end

  it 'requires a unique path' do
    subject.save
    store = FactoryGirl.build(:store, path: 'petals-purses-and-pastries')
    expect(store).to_not be_valid
  end

  it 'requires a status' do
    expect { subject.status = '' }.to change{ subject.valid? }.to(false)
  end

  it 'requires a status within the valid set' do
    expect { subject.status = 'abc' }.to change{ subject.valid? }.to(false)
  end

  it 'parameterizes path before validation' do
    subject.path = "Oh yeah"
    subject.save
    expect(subject.path).to eq('oh-yeah')
  end

  context 'is_admin?' do
    it 'returns true when user is uber' do
      user = FactoryGirl.create(:user)
      user.uber_up
      expect(subject.is_admin?(user)).to eq true
    end

    it 'returns true when user is admin for store' do
      user = FactoryGirl.create(:user)
      subject.save
      Role.promote(user, subject, 'admin')
      expect(subject.is_admin?(user)).to eq true
    end

    it 'returns false when user is admin for another store' do
      user = FactoryGirl.create(:user)
      store = FactoryGirl.create(:store)
      Role.promote(user, store, 'admin')
      expect(subject.is_admin?(user)).to eq false
    end
  end

  it 'to_param' do
    expect(subject.to_param).to eq subject.path
  end

  it 'pending?' do
    expect(subject.pending?).to eq true
  end

  describe 'toggle_online_status' do
    it 'toggles online to offline' do
      subject.status = 'online'
      subject.toggle_online_status(:uber)
      expect(subject.status).to eq 'offline'
    end

    it 'toggles offline to online' do
      subject.status = 'offline'
      subject.toggle_online_status(:uber)
      expect(subject.status).to eq 'online'
    end

    it 'does not change status where not offline or online' do
      subject.toggle_online_status(:uber)
      expect(subject.status).to eq 'pending'
    end
  end

  describe '.popular' do
    it 'delegates to LocalStore.popular' do
      subject.save
      LocalStore.stub(:popular).and_return(subject.id)
      popular = Store.popular
      expect(popular).to eq subject
    end
  end

  describe '.recent' do
    it 'select the most recently added store' do
      s1 = FactoryGirl.create(:store)
      s2 = FactoryGirl.create(:store)
      recent = Store.recent
      expect(recent).to eq s2
    end
  end
end
