require 'rails_helper'

RSpec.describe Rank, :type => :model do
  it { should have_many(:gundams_ranks) }

  describe "#no" do
    it { should validate_presence_of(:no) }
  end

  describe "#rank" do
    it { should validate_presence_of(:rank) }
  end
end
