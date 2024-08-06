require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:store) { create(:store, name: "fav_store", google_place_id: "favorite_store_1") }
  let!(:fav_store) { create(:favorite, user_id: user.id, google_place_id: store.google_place_id) }
  let!(:other_store) { create(:store, name: "unfavorite_store", google_place_id: "unfavorite_store_1") }

  describe "GET /index" do
    before do
      sign_in user
      allow(Client).to receive(:spot).and_return(
        OpenStruct.new(
          placeid: "favorite_store_1",
          name: "fav_store",
          formatted_address: "123 Tokyo St"
        )
      )
      get my_stores_favorites_path
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "ログインユーザーがお気に入りした店の名前が表示されること" do
      expect(response.body).to include(store.name)
    end

    it "お気に入りされていない店の名前が表示されないこと" do
      expect(response.body).not_to include("unfavorite_store")
    end
  end

  describe "POST /create" do
    before do
      sign_in user
      post store_favorites_path(store_google_place_id: store.google_place_id)
    end

    it "ストアをお気に入りした後に元の画面にリダイレクトされること" do
      expect(response).to redirect_to(store_path(google_place_id: store.google_place_id))
    end
  end

  describe "DELETE /destroy" do
    before do
      sign_in user
      delete store_favorites_path(store_google_place_id: store.google_place_id)
    end

    it "ストアをお気に入りから削除した際に元の画面にリダイレクトされること" do
      expect(response).to redirect_to(store_path(google_place_id: store.google_place_id))
    end
  end
end
