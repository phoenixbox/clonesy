require 'spec_helper'

describe UserStoreRole do
  subject do
    UserStoreRole.new({ user_id: 1,
                        store_id: 1,
                        role: 'admin'}, as: :uber)
  end

  it 'has a valid subject' do
    expect(subject).to be_valid
  end

  it 'requires a user reference' do
    expect { subject.user_id = nil }.to change { subject.valid? }.to(false)
  end

  it 'requires a store reference' do
    expect { subject.store_id = nil }.to change { subject.valid? }.to(false)
  end

  it 'requires a role' do
    expect { subject.role = '' }.to change { subject.valid? }.to(false)
  end

  it 'requires a valid role' do
    expect { subject.role = 'abc' }.to change { subject.valid? }.to(false)
  end
end
