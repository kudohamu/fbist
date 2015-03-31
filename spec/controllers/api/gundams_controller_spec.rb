require 'rails_helper'

RSpec.describe Api::GundamsController, :type => :controller do
  describe "#index" do
    describe "はログインしていないとき" do
      let(:user) { build(:user) }
      before do
        @all_gundam = create(:all_gundam)
        @gundams = create_list(:gundam, 10)

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
      let(:user) { build(:user) }
      before do
        @all_gundam = create(:all_gundam)
        @gundams = create_list(:gundam, 10)
        login_user user
      end

      describe "でallオプションパラメータを付けていないとき" do
        before do
          get :index
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonの配列サイズが@gundamsのサイズと同じであること" do
          expect(@json.size).to eq(@gundams.count)
        end

        it "jsonデータのそれぞれが@gundamsの各データの内容と対応していること" do
          @gundams.count.times do |i|
            expect(@json[i]["id"]).to eq(@gundams[i].id)
            expect(@json[i]["no"]).to eq(@gundams[i].no)
            expect(@json[i]["image_path"]).to eq(@gundams[i].icon.url)
            expect(@json[i]["name"]).to eq(@gundams[i].name)
            expect(@json[i]["cost"]).to eq(@gundams[i].cost.cost)
          end
        end

        it "gundamに関する表示する予定のないデータが入っていないこと" do
          @gundams.count.times do |i|
            expect(@json[i]["wiki"]).to be_nil
          end
        end
      end

      describe "でallオプションパラメータを付けているとき" do
        before do
          get :index, { all: true }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "jsonの配列サイズが@gundamsのサイズ+1であること" do
          expect(@json.size).to eq(@gundams.count + 1)
        end

        it "jsonデータの1番目が@all_gundamの内容と同じであること" do
          expect(@json[0]["id"]).to eq(@all_gundam.id)
          expect(@json[0]["no"]).to eq(@all_gundam.no)
          expect(@json[0]["image_path"]).to eq(@all_gundam.icon.url)
          expect(@json[0]["name"]).to eq(@all_gundam.name)
          expect(@json[0]["cost"]).to eq(@all_gundam.cost.cost)
        end

        it "jsonデータの1番目以降のそれぞれが@gundamsの各データの内容と対応していること" do
          @gundams.count.times do |i|
            expect(@json[i+1]["id"]).to eq(@gundams[i].id)
            expect(@json[i+1]["no"]).to eq(@gundams[i].no)
            expect(@json[i+1]["image_path"]).to eq(@gundams[i].icon.url)
            expect(@json[i+1]["name"]).to eq(@gundams[i].name)
            expect(@json[i+1]["cost"]).to eq(@gundams[i].cost.cost)
          end
        end

        it "gundamに関する表示する予定のないデータが入っていないこと" do
          @json.size.times do |i|
            expect(@json[i]["wiki"]).to be_nil
          end
        end
      end
    end
  end
end
