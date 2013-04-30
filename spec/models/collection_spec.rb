require 'spec_helper'

describe Collection do
  let!(:user){ FactoryGirl.create(:user) }

  subject do
    user.collections.create(name: 'Hotness')
  end

  it "requires a name" do
    expect { subject.name = '' }.to change { subject.valid? }.to(false)
  end

  it "requires a user" do
    expect { subject.user = nil }.to change { subject.valid? }.to(false)
  end
end
