require 'rails_helper'

RSpec.describe Api::RecordsController, :type => :controller do
  before do
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
        @gundam = create(:gundam)
      end
      describe "でoffsetが0のとき" do
        before do
          login_user @user
          
          @records = create_list(:record, 70, user: @user, gundam: @gundam)
          get :index
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "@jsonのサイズが30であること" do
          expect(@json.size).to eq(30)
        end

        it "@jsonの順番がrecordの最新30件であること" do
          30.times do |i|
            expect(@json[i]["id"]).to eq(@records[@records.length - 1 - i].id)
          end
        end
      end

      describe "でoffsetが30のとき" do
        before do
          login_user @user
          
          @records = create_list(:record, 70, user: @user, gundam: @gundam)
          get :index, { offset: 30 }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "@jsonのサイズが30であること" do
          expect(@json.size).to eq(30)
        end

        it "@jsonの順番がrecordの最新31件目~60件目であること" do
          30.times do |i|
            expect(@json[i]["id"]).to eq(@records[@records.length - 30 - 1 - i].id)
          end
        end
      end

      describe "でoffsetが60のとき" do
        before do
          login_user @user
          
          @records = create_list(:record, 70, user: @user, gundam: @gundam)
          get :index, { offset: 60 }
          @json = JSON.parse(response.body)
        end

        it "ステータスコードが200であること" do
          expect(response.status).to eq(200)
        end

        it "@jsonのサイズが10であること" do
          expect(@json.size).to eq(10)
        end

        it "@jsonの順番がrecordの最新61件目~70件目であること" do
          10.times do |i|
            expect(@json[i]["id"]).to eq(@records[@records.length - 60 - 1 - i].id)
          end
        end
      end
    end
  end

  describe "#create" do
    describe "はログインしていないとき" do
      before do
        post :create
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
        @gundam = create(:gundam)
        @friend = create(:friend)

        login_user @user
      end

      describe "でgundam_idとfriend_idの両方が正しいとき" do
        it "ステータスコードが200であること" do
          post :create, { record: { gundam_id: @gundam.id, won: true, free: false, ranked: true, friend_id: @friend.id } }
          expect(response.status).to eq(200)
        end

        it "Recordのデータが入っていること" do
          expect{
            post :create, { record: { gundam_id: @gundam.id, won: true, free: false, ranked: true, friend_id: @friend.id } }
          }.to change(Record, :count).by(1)
        end
      end

      describe "でgundam_idが存在しないとき" do
        it "例外が発生すること" do
          expect{
            post :create, { record: { gundam_id: -1, won: true, free: false, ranked: true, friend_id: @friend.id } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end

      describe "でfriend_idが存在しないとき" do
        it "例外が発生すること" do
          expect{
            post :create, { record: { gundam_id: @gundam.id, won: true, free: false, ranked: true, friend_id: -1 } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end
    end
  end

  describe "#update" do
    before do
      @gundam = create(:gundam)
      @friend = create(:friend)

      @record = create(:record, user: @user, gundam: @gundam, won: true, free: false, ranked: true, friend: @friend)
      @other_user_record = create(:record, gundam: @gundam, won: true, free: false, ranked: true, friend: @friend)
    end

    describe "はログインしていないとき" do
      before do
        patch :update, { id: @record.id }
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
        login_user @user
        @params = { id: @record.id, record: { gundam_id: @gundam.id, won: true, free: true, ranked: true, friend_id: @friend.id } }
      end

      describe "でgundam_idとfriend_idの両方が正しいとき" do
        it "ステータスコードが200であること" do
          patch :update, @params
          expect(response.status).to eq(200)
        end

        it "Recordのデータが増えていないこと" do
          expect{
            patch :update, @params
          }.to change(Record, :count).by(0)
        end

        it "freeがtrueになっていること" do
          patch :update, @params
          expect(Record.find(@record.id).free).to be_truthy
        end
      end

      describe "でgundam_idが存在しないとき" do
        it "例外が発生すること" do
          expect{
            patch :update, { id: @record.id, record: { gundam_id: -1, won: true, free: true, ranked: true, friend_id: @friend.id } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end

      describe "でfriend_idが存在しないとき" do
        it "例外が発生すること" do
          expect{
            patch :update, { id: @record.id, record: { gundam_id: @gundam.id, won: true, free: true, ranked: true, friend_id: -1 } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end

      describe "でidが存在しないとき" do
        it "例外が発生すること" do
          expect{
            patch :update, { id: -1, record: { gundam_id: @gundam.id, won: true, free: true, ranked: true, friend_id: -1 } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end

      describe "で違うユーザのrecordのとき" do
        it "例外が発生すること" do
          expect{
            patch :update, { id: @other_user_record.id, record: { gundam_id: @gundam.id, won: true, free: true, ranked: true, friend_id: -1 } }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end
    end
  end

  describe "#destroy" do
    before do
      @gundam = create(:gundam)
      @friend = create(:friend)

      @record = create(:record, user: @user, gundam: @gundam, won: true, free: false, ranked: true, friend: @friend)
      @other_user_record = create(:record, gundam: @gundam, won: true, free: false, ranked: true, friend: @friend)
    end

    describe "はログインしていないとき" do
      before do
        post :destroy, { id: @record.id }
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
        login_user @user
        @params = { id: @record.id }
      end

      describe "でgundam_idとfriend_idの両方が正しいとき" do
        it "ステータスコードが200であること" do
          post :destroy, @params
          expect(response.status).to eq(200)
        end

        it "Recordのデータが消えていること" do
          expect{
            post :destroy, @params
          }.to change(Record, :count).by(-1)
        end
      end

      describe "でidが存在しないとき" do
        it "例外が発生すること" do
          expect{
            post :destroy, { id: -1 }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end

      describe "で違うユーザのrecordのとき" do
        it "例外が発生すること" do
          expect{
            patch :update, { id: @other_user_record.id }
          }.to raise_error(ApplicationController::BadRequest)
        end
      end
    end
  end
end
