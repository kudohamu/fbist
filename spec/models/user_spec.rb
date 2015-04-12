require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many(:records) }
  it { should have_many(:friendlist_of_from_user).with_foreign_key(:from_user_id) }
  it { should have_many(:friendlist_of_to_user).with_foreign_key(:to_user_id) }
  it { should have_many(:friends_of_from_user) }
  it { should have_many(:friends_of_to_user) }

  describe "#name" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(20) }
  end

  describe "#icon" do
    it { should validate_presence_of(:icon) }
  end
end
