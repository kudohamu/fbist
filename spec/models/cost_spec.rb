require 'rails_helper'

RSpec.describe Cost, :type => :model do
  it { should have_many(:gundams) }

  describe "#cost" do
    it { should validate_presence_of(:cost) }
    it { should validate_uniqueness_of(:cost) }

    describe "は-1のとき" do
      it "validであること" do
        cost = build(:cost, cost: -1)
        cost.valid?
        expect(cost.errors[:cost]).to be_present
      end
    end

    describe "は0のとき" do
      it "validであること" do
        cost = build(:cost, cost: 0)
        cost.valid?
        expect(cost.errors[:cost]).to be_present
      end
    end

    describe "は1のとき" do
      it "validでないこと" do
        cost = build(:cost, cost: 1)
        cost.valid?
        expect(cost.errors[:cost]).to be_blank
      end
    end

    describe "は10001のとき" do
      it "validであること" do
        cost = build(:cost, cost: 10001)
        cost.valid?
        expect(cost.errors[:cost]).to be_present
      end
    end

    describe "は10000のとき" do
      it "validであること" do
        cost = build(:cost, cost: 10000)
        cost.valid?
        expect(cost.errors[:cost]).to be_present
      end
    end

    describe "は9999のとき" do
      it "validでないこと" do
        cost = build(:cost, cost: 9999)
        cost.valid?
        expect(cost.errors[:cost]).to be_blank
      end
    end
  end
end
