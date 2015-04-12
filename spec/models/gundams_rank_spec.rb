require 'rails_helper'

RSpec.describe GundamsRank, :type => :model do
  describe "rank_id" do
    it { should belong_to(:rank) }
    it { should validate_presence_of(:rank_id) }
  end

  describe "gundam_id" do
    it { should belong_to(:gundam) }
    it { should validate_presence_of(:gundam_id) }
  end
end
