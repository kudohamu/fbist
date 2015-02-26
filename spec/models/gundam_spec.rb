require 'rails_helper'

RSpec.describe Gundam, :type => :model do
  it { should have_many(:records) }

  describe "#name" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(45) }

    describe "は同じ名前が存在するとき" do
      it "validであること" do
        another_gundam = create(:gundam, name: "フルバーニアン");
        gundam = build(:gundam, name: "フルバーニアン");
        gundam.valid?
        expect(gundam.errors[:name]).to be_present
      end
    end

    describe "は同じ名前が存在しないとき" do
      it "validでないこと" do
        another_gundam = create(:gundam, name: "フルバーニアン");
        gundam = build(:gundam, name: "ゼフィランサス");
        gundam.valid?
        expect(gundam.errors[:name]).to be_blank
      end
    end
  end

  describe "#no" do
    it { should validate_presence_of(:no) }


    describe "は同じnoが存在するとき" do
      it "validであること" do
        another_gundam = create(:gundam, no: 5000);
        gundam = build(:gundam, no: 5000);
        gundam.valid?
        expect(gundam.errors[:no]).to be_present
      end
    end

    describe "は同じnoが存在しないとき" do
      it "validでないこと" do
        another_gundam = create(:gundam, no: 5000);
        gundam = build(:gundam, no: 5001);
        gundam.valid?
        expect(gundam.errors[:no]).to be_blank
      end
    end

    describe "は-1のとき" do
      it "validであること" do
        gundam = build(:gundam, no: -1)
        gundam.valid?
        expect(gundam.errors[:no]).to be_present
      end
    end

    describe "は0のとき" do
      it "validであること" do
        gundam = build(:gundam, no: 0)
        gundam.valid?
        expect(gundam.errors[:no]).to be_present
      end
    end

    describe "は1のとき" do
      it "validでないこと" do
        gundam = build(:gundam, no: 1)
        gundam.valid?
        expect(gundam.errors[:no]).to be_blank
      end
    end

    describe "は1000001のとき" do
      it "validであること" do
        gundam = build(:gundam, no: 1000001)
        gundam.valid?
        expect(gundam.errors[:no]).to be_present
      end
    end

    describe "は1000000のとき" do
      it "validであること" do
        gundam = build(:gundam, no: 1000000)
        gundam.valid?
        expect(gundam.errors[:no]).to be_present
      end
    end

    describe "は999999のとき" do
      it "validでないこと" do
        gundam = build(:gundam, no: 999999)
        gundam.valid?
        expect(gundam.errors[:no]).to be_blank
      end
    end
  end

  describe "#wiki" do
    it { should validate_presence_of(:wiki) }
    it { should ensure_length_of(:wiki).is_at_most(500) }

    describe "は同じwikiが存在するとき" do
      it "validであること" do
        another_gundam = create(:gundam, wiki: "hoge09.html");
        gundam = build(:gundam, wiki: "hoge09.html");
        gundam.valid?
        expect(gundam.errors[:wiki]).to be_present
      end
    end

    describe "は同じwikiが存在しないとき" do
      it "validでないこと" do
        another_gundam = create(:gundam, wiki: "hoge09.html");
        gundam = build(:gundam, wiki: "hoge10.html");
        gundam.valid?
        expect(gundam.errors[:wiki]).to be_blank
      end
    end

    describe "は使用不可能な文字が入っているとき" do
      it "validであること" do
        gundam = build(:gundam, wiki: "32.html%0d%0ahttp://hoge.php")
        gundam.valid?
        expect(gundam.errors[:wiki]).to be_present
      end
    end

    describe "は使用不可能な文字が入っていないとき" do
      it "validでないこと" do
        gundam = build(:gundam, wiki: "32.html")
        gundam.valid?
        expect(gundam.errors[:wiki]).to be_blank
      end
    end
  end

  describe "#cost_id" do
    it { should belong_to(:cost) }
  end
end
