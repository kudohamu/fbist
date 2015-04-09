require 'rails_helper'

RSpec.describe Api::UsersController, :type => :controller do
  describe "#index" do
    let(:all) { create(:user, id: 1) }
    let(:other) { create(:user, id: 2) }
    let(:user) { create(:user, id: 3) }
    describe "はログインしていないとき" do
      before do
        @users = create_list(:user, 20)
        @followee = create_list(:user, 4)
        @follower = create_list(:user, 5)

        @followee.each do |followee|
          create(:friend_list, from_user_id: 3, to_user: followee)
        end

        @follower.each do |follower|
          create(:friend_list, from_user: follower, to_user_id: 3)
        end

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
        @users = create_list(:user, 20)
        @followee = create_list(:user, 4)
        @follower = create_list(:user, 5)

        @followee.each do |followee|
          create(:friend_list, from_user_id: 3, to_user: followee)
        end

        @follower.each do |follower|
          create(:friend_list, from_user: follower, to_user_id: 3)
        end

        sign_in user
        get :index
        @json = JSON.parse(response.body)
      end

      it "ステータスコードが200であること" do
        expect(response.status).to eq(200)
      end

      it "jsonの配列サイズに'すべて'と'その他'と自分とフォロイーの数が含まれていないこと" do
        expect(@json.size).to eq(@users.length + @follower.length)
      end

      it "jsonに'すべて'が含まれないこと" do
        result = @json.select { |json| json["id"] == all.id }
        expect(result.size).to eq(0)
      end

      it "jsonに'その他'が含まれないこと" do
        result = @json.select { |json| json["id"] == other.id }
        expect(result.size).to eq(0)
      end

      it "jsonに'自分'が含まれないこと" do
        result = @json.select { |json| json["id"] == user.id }
        expect(result.size).to eq(0)
      end

      it "jsonにフォロイーが含まれないこと" do
        @followee.each do |followee|
          @json.select! { |json| json["id"] != user.id }
        end
        expect(@json.size).to eq(@users.length + @follower.length)
      end
    end
  end
end
