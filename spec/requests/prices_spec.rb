require 'rails_helper'

RSpec.describe "Prices", type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category_id: category.id) }
  let(:store) { create(:store) }
  let!(:price) { create(:price, product_id: product.id, google_place_id: store.google_place_id, user_id: user.id) }
  let(:valid_price_attributes) do
    attributes_for(:price, product_id: product.id, user_id: user.id, google_place_id: store.google_place_id)
  end
  let(:invalid_price_attributes) do
    attributes_for(:price, price_value: "", product_id: product.id, user_id: user.id, google_place_id: store.google_place_id)
  end
  let(:updated_attributes) { { price_value: 999, google_place_id: store.google_place_id, product_id: product.id } }
  let(:invalid_update_attributes) { { price_value: nil, google_place_id: store.google_place_id, product_id: product.id } }

  before do
    allow(Client).to receive(:spot).and_return(OpenStruct.new(name: store.name, formatted_address: "Test Address",
                                                              placeid: store.google_place_id))
    sign_in user
  end

  describe "GET /index" do
    before do
      get store_prices_path(store_google_place_id: store.google_place_id, product_id: product.id)
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "パラメーターのproduct_idと一致する商品が取得できること" do
      expect(response.body).to include(product.name)
    end

    it "パラメーターのgoogle_place_idとproduct_idに一致する商品価格情報が取得できること" do
      expect(response.body).to include(price.price_value.to_s)
    end

    it "パラメーターのgoogle_place_idと一致するストア情報が取得できること" do
      expect(response.body).to include(store.name)
    end
  end

  describe "GET /new" do
    before do
      get new_store_price_path(store_google_place_id: store.google_place_id, product_id: product.id)
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /create" do
    context "パラメーターが適切な場合" do
      before do
        post store_prices_path(store_google_place_id: store.google_place_id), params: { price: valid_price_attributes }
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(302)
      end

      it "商品価格を保存できること" do
        expect(response).to redirect_to(store_prices_path(google_place_id: store.google_place_id, product_id: product.id))
        follow_redirect!
        expect(response.body).to include("商品価格を投稿しました")
      end
    end

    context "パラメーターが不正な場合" do
      before do
        post store_prices_path(store_google_place_id: store.google_place_id), params: { price: invalid_price_attributes }
      end

      it "商品価格を保存できないこと" do
        expect(response).to have_http_status(200)
        expect(response.body).to include("投稿に失敗しました")
      end
    end
  end

  describe "GET /edit" do
    before do
      get edit_price_path(price, google_place_id: store.google_place_id, product_id: product.id)
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /update" do
    context "パラメーターが適切な場合" do
      before do
        patch price_path(price, google_place_id: store.google_place_id, product_id: product.id),
  params: { price: updated_attributes }
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(302)
      end

      it "価格情報の更新に成功すること" do
        expect(price.reload.price_value).to eq(999)
      end

      it "リダイレクト後に、価格情報の更新に成功した旨のメッセージが表示されること" do
        expect(response).to redirect_to(own_prices_path)
        follow_redirect!
        expect(response.body).to include("価格情報を更新しました")
      end
    end

    context "パラメーターが適切でない場合" do
      before do
        patch price_path(price, google_place_id: store.google_place_id, product_id: product.id),
              params: { price: invalid_update_attributes }
      end

      it "価格情報の更新に失敗すること" do
        expect(response).to have_http_status(200)
        expect(response.body).to include("価格情報の更新に失敗しました")
      end
    end
  end

  describe "DELETE /destroy" do
    before do
      delete price_path(price, store_google_place_id: store.google_place_id, product_id: product.id)
    end

    it "価格情報の削除に成功すること" do
      expect(response).to redirect_to(own_prices_path)
      follow_redirect!
      expect(response.body).to include("価格情報を削除しました")
    end
  end

  describe "GET /own_prices" do
    before do
      get own_prices_path
    end
    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "現在ログインしているユーザーの関連の商品価格情報のみが取得できること" do
      expect(response.body).to include(price.price_value.to_s)
    end
  end

  describe "GET /result" do
    before do
      get result_path
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /own_result" do
    before do
      get own_prices_result_prices_path
    end

    it "レスポンスを返すこと" do
      expect(response).to have_http_status(200)
    end

    it "お気に入りした店舗に関連する価格情報にて検索結果が表示できること" do
      expect(response.body).to include(price.price_value.to_s)
    end
  end
end
