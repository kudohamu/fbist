require 'rails_helper'

RSpec.describe Record, :type => :model do
  describe "#user_id" do
    it { should belong_to(:user) }
  end

  describe "#gundam_id" do
    it { should belong_to(:gundam) }
  end
end
