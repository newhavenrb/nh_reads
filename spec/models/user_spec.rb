# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  name                   :string(255)
#

require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:orders) }

  it { should be_valid }

  describe "when email is blank" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "order associations" do
    before { user.save }
    let!(:older_order) do
      FactoryGirl.create(:order, user: user, created_at: 1.day.ago)
    end
    let!(:newer_order) do
      FactoryGirl.create(:order, user: user, created_at:1.hour.ago)
    end

    it "should have the correct orders in the right order" do  # checks order of orders
      user.orders.should == [newer_order, older_order]
    end

    it "should destroy associated orders on deletion" do
      orders = user.orders
      user.destroy
      orders.each do |order|
        Order.find_by_id(order.id).should be_nil
      end
    end
  end
end
