require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should have_many(:records) }

  describe "#name" do
    it { should validate_presence_of(:name) }
    it { should ensure_length_of(:name).is_at_most(20) }
  end

  describe "#mail" do
    it { should ensure_length_of(:mail).is_at_most(255) }
    it { should validate_presence_of(:mail) }

    context "がドットの連続するメールアドレス形式のとき" do
      it "validであること" do
        user = build(:user)
        user.mail = "hoge..hog+_-e@g-mail.com"
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "がドットで始まるメールアドレス形式のとき" do
      it "validであること" do
        user = build(:user)
        user.mail = ".hoge_hog+_-e@g-mail.com"
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が@の前がドットで終わるメールアドレス形式のとき" do
      it "validであること" do
        user = build(:user)
        user.mail = "hoge_hog+_-e.@g-mail.com"
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が使用不可能な記号を使ったメールアドレス形式のとき" do
      it "validであること" do
        user = build(:user)
        user.mail = "ho@ge_hog+_-e.@g-mail.com"
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が@の後ろが不正なメールアドレス形式のとき" do
      it "validであること" do
        user = build(:user)
        user.mail = "hoge_hog+_-e.@g-ma_il.com"
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が正しいメールアドレス形式のとき" do
      it "validでないこと" do
        user = build(:user)
        user.mail = "hoge_hog+_-e@g-mail.com"
        user.valid?
        expect(user.errors[:mail]).to be_blank
      end
    end

    context "が大文字小文字が同じメールアドレスを登録するとき" do
      it "validであること" do
        create(:user, mail: "fbist@gmail.com")
        user = build(:user, mail: "fbist@gmail.com")
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が大文字小文字は違うが文字列の同じメールアドレスを登録するとき" do
      it "validであること" do
        create(:user, mail: "fbist@gmail.com")
        user = build(:user, mail: "FBist@gmail.com")
        user.valid?
        expect(user.errors[:mail]).to be_present
      end
    end

    context "が違うメールアドレスを登録するとき" do
      it "validでないこと" do
        create(:user, mail: "fbist@gmail.com")
        user = build(:user, mail: "fbiest@gmail.com")
        user.valid?
        expect(user.errors[:mail]).to be_blank
      end
    end
  end

  describe "#password" do
    it { should ensure_length_of(:password).is_at_least(6) }
    it { should ensure_length_of(:password).is_at_most(32) }
    it { should validate_presence_of(:password) }

    context "が使用不可能な記号を含むとき" do
      it "validであること" do
        user = build(:user)
        user.password = "<hogehoge>"
        user.password_confirmation = "<hogehoge>"
        user.valid?
        expect(user.errors[:password]).to be_present
      end
    end

    context "が平仮名を含むとき" do
      it "validであること" do
        user = build(:user)
        user.password = "ほげhogen"
        user.password = "ほげhogen"
        user.valid?
        expect(user.errors[:password]).to be_present
      end
    end

    context "が全角英文字を含むとき" do
      it "validであること" do
        user = build(:user)
        user.password = "ｈogeｈoge"
        user.password_confirmation = "ｈogeｈoge"
        user.valid?
        expect(user.errors[:password]).to be_present
      end
    end

    context "が使用可能な文字のみを含むとき" do
      it "validでないこと" do
        user = build(:user)
        user.password = "hoge_hoge"
        user.password_confirmation = "hoge_hoge"
        user.valid?
        expect(user.errors[:password]).to be_blank
      end
    end
  end

  describe "#password_confirmation" do
    context "が#passwordと違うとき" do
      it "validであること" do
        user = build(:user)
        user.password = "hoge_hoge"
        user.password_confirmation = "hoge__hoge"
        user.valid?
        expect(user.errors[:password_confirmation]).to be_present
      end
    end

    context "が#passwordと同じとき" do
      it "validでないこと" do
        user = build(:user)
        user.password = "hoge_hoge"
        user.password_confirmation = "hoge_hoge"
        user.valid?
        expect(user.errors[:password_confirmation]).to be_blank
      end
    end
  end
end
