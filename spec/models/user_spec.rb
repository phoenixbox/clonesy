require 'spec_helper'

describe User do
  subject do
    User.new(
      full_name: 'Shane Rogers',
      email: 'shane@therogers.com',
      display_name: 'sdrogers',
      password: 'password'
      )
  end

  it 'has a valid subject' do
    expect( subject ).to be_valid
  end

  it 'requires an email' do
    expect { subject.email = '' }.to change { subject.valid? }.to(false)
  end

  it 'is invalid with a duplicate email' do
    subject.save
    user = FactoryGirl.build(:user, email: 'shane@therogers.com')
    expect(user).to_not be_valid
  end

  it 'is invalid without a password' do
    expect { subject.password = '' }.to change { subject.valid? }.to(false)
  end

  it 'is invalid without a full name' do
    expect { subject.full_name = '' }.to change { subject.valid? }.to(false)
  end

  it 'is valid with no display name' do
    expect { subject.display_name = '' }.to_not change { subject.valid? }
  end

  it 'is invalid if display name is not between 2-32 chars if it exists' do
    expect{ subject.display_name = 'p' }.to change { subject.valid? }.to(false)
    expect{ subject.display_name = 'p'*33 }.to_not change { subject.valid? }
    expect{ subject.display_name = 'p'*32 }.to change { subject.valid? }.to(true)
  end

  describe '.new_guest' do
    let(:user) { User.new_guest(full_name: 'someone',
                                email: 'some@email.com',
                                password: 'pass') }

    it 'produces a valid used with correct params' do
      expect( user ).to be_valid
    end

    it 'passes ' do
      expect( user ).to be_valid
    end

    it 'produces an orphaned user' do
      expect( user ).to be_orphan
    end
  end

  describe '#uber_up' do
    it 'promotes user to uber' do
      expect { subject.uber_up}.to change { subject.uber }.to(true)
    end
  end

  describe '#uber?' do
    it 'responds with uber value' do
      expect(subject.uber?).to eq false
    end
  end

  describe '#orphan?' do
    it 'responds with orphan value' do
      expect(subject.orphan?).to eq false
    end
  end
end
