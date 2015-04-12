require 'rails_helper'

RSpec.describe FriendList, :type => :model do
  describe "#from_user_id" do
    it { should belong_to(:from_user) }
    it { should validate_presence_of(:from_user_id) }
  end

  describe "#to_user_id" do
    it { should belong_to(:to_user) }
    it { should validate_presence_of(:to_user_id) }
  end
end
