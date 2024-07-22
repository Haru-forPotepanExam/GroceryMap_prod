require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:fav_store) { create(:favorite, user: user, google_place_id: store.google_place_id) }
  let(:other_store) { create(:store, name: "unfavorite_store") }

  describe "GET /index" do
    before do
      sign_in user
      get my_stores_favorites_path
    end

    it "レスポンスを返すこと" do
      get "/favorites/index"
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
      post favorites_path, params: { store_google_place_id: store.google_place_id }
    end

    it "ストアをお気に入りした後に元の画面にリダイレクトされること" do
      expect(response).to redirect_to(request.referer)
    end
  end

  describe "DELETE /destroy" do
    before do
      sign_in user
      delete favorite_path(store_google_place_id: store.google_place_id)
    end

    it "ストアをお気に入りから削除した際に元の画面にリダイレクトされること" do
      expect(response).to redirect_to(request.referer)
    end
  end
end
