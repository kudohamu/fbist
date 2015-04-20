require 'rails_helper'

RSpec.describe Api::FriendsController, :type => :controller do
  before do
    @all = create(:user, id: 1, name: "all")
    @other = create(:user, id: 2, name: "other")
    @user = create(:user)
  end
  describe "#index" do
    describe "はログインしていないとき" do
      before do
        get :index       
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end

      it "ログインページ（トップ）にリダイレクトすること" do
        should redirect_to "/"
      end
    end

    describe "はログインしているとき" do
      before do
        @followee = create_list(:friend_list, 10, from_user: @user, to_user: create(:user))
        @follower = create_list(:friend_list, 12, from_user: create(:user), to_user: @user)

        @other_users = create_list(:user, 10)
      end

      describe "はotherオプションもallオプションもfalseのとき" do
        before do
          login_user @user
          get :index
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数と同じであること" do
          expect(@json.size).to eq(@followee.length)
        end
      end

      describe "はotherオプションがtrueのとき" do
        before do
          login_user @user
          get :index, { other: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+1であること" do
          expect(@json.size).to eq(@followee.length + 1)
        end

        it "先頭のユーザがid: 2のユーザであること" do
          expect(@json[0]["id"]).to eq(@other.id)
        end
      end

      describe "はallオプションがtrueのとき" do
        before do
          login_user @user
          get :index, { all: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+1であること" do
          expect(@json.size).to eq(@followee.length + 1)
        end

        it "先頭のユーザがid: 1のユーザであること" do
          expect(@json[0]["id"]).to eq(@all.id)
        end
      end

      describe "はallオプションもotherオプションもtrueのとき" do
        before do
          login_user @user
          get :index, { all: true, other: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+2であること" do
          expect(@json.size).to eq(@followee.length + 2)
        end

        it "先頭のユーザがid: 1のユーザであること" do
          expect(@json[0]["id"]).to eq(@all.id)
        end

        it "2番目のユーザがid: 2のユーザであること" do
          expect(@json[1]["id"]).to eq(@other.id)
        end
      end
    end
  end

  describe "#follower" do
    describe "はログインしていないとき" do
      before do
        get :follower
      end

      it "ステータスコードが302であること" do
        expect(response.status).to eq(302)
      end

      it "ログインページ（トップ）にリダイレクトすること" do
        should redirect_to "/"
      end
    end

    describe "はログインしているとき" do
      before do
        @followee = create_list(:friend_list, 10, from_user: @user, to_user: create(:user))
        @follower = create_list(:friend_list, 12, from_user: create(:user), to_user: @user)

        @other_users = create_list(:user, 10)
      end

      describe "はotherオプションもallオプションもfalseのとき" do
        before do
          login_user @user
          get :follower
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数と同じであること" do
          expect(@json.size).to eq(@follower.length)
        end
      end

      describe "はotherオプションがtrueのとき" do
        before do
          login_user @user
          get :follower, { other: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+1であること" do
          expect(@json.size).to eq(@follower.length + 1)
        end

        it "先頭のユーザがid: 2のユーザであること" do
          expect(@json[0]["id"]).to eq(@other.id)
        end
      end

      describe "はallオプションがtrueのとき" do
        before do
          login_user @user
          get :follower, { all: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+1であること" do
          expect(@json.size).to eq(@follower.length + 1)
        end

        it "先頭のユーザがid: 1のユーザであること" do
          expect(@json[0]["id"]).to eq(@all.id)
        end
      end

      describe "はallオプションもotherオプションもtrueのとき" do
        before do
          login_user @user
          get :follower, { all: true, other: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonのサイズがフォロイー数+2であること" do
          expect(@json.size).to eq(@follower.length + 2)
        end

        it "先頭のユーザがid: 1のユーザであること" do
          expect(@json[0]["id"]).to eq(@all.id)
        end

        it "2番目のユーザがid: 2のユーザであること" do
          expect(@json[1]["id"]).to eq(@other.id)
        end
      end
    end
  end
end
