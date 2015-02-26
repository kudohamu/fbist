require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many(:records) }

  describe "#name" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(20) }
  end
end
