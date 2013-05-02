require 'spec_helper'

describe Mailer do
  let!(:user){FactoryGirl.create(:user)}
  let!(:store){FactoryGirl.create(:store)}

  it 'sends a welcome email' do
    email = Mailer.welcome_email(user, user.full_name).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email).to have_content "Thanks for signing up"
  end

  it 'sends an order confirmation email' do
    order = FactoryGirl.create(:order, user: user)
    order.guid = "randomstring-here-I-am"
    order.save!
    email = Mailer.order_confirmation(user, order, order.total).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email).to have_content order.guid
    expect(email).to have_content "for your purchase"
  end

  it 'sends a role confirmation email' do
    email = Mailer.role_confirmation(user, store, 'admin').deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email).to have_content "You've been promoted to a admin"
  end

  it 'sends a role invitation email' do
    email = Mailer.role_invitation('a@b.c', user, store, 'admin').deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email).to have_content "You've been invited to become a admin"
  end

  it 'sends a revoke role message' do
    name = store.name
    email = Mailer.revoke_role(user, store).deliver
    expect(ActionMailer::Base.deliveries).to_not be_empty
    expect(email).to have_content "your role with #{name} has been revoked"
  end
end
