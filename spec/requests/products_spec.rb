require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:category) { create(:category) }
  let(:valid_attributes) { { name: "Sample Product", category_id: category.id } }
  let(:invalid_attributes) { { name: "", category_id: nil } }

  describe "POST /create" do
    before do
      sign_in user
    end

    context "パラメーターが正しい場合" do
      before do
        get new_product_path, params: { store_google_place_id: store.google_place_id }
        post products_path, params: { product: valid_attributes, store_google_place_id: store.google_place_id }
        allow(Client).to receive(:spot).and_return(
          OpenStruct.new(
            placeid: store.google_place_id,
            name: "store",
            formatted_address: "123 Tokyo St",
            opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] }
          )
        )
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(302)
      end

      it "商品が追加された際にメッセージが表示されること" do
        expect(response).to redirect_to(store_path(store.google_place_id))
        follow_redirect!
        expect(response.body).to include("商品を追加しました。")
      end
    end

    context "パラメーターが不正の場合" do
      before do
        post products_path, params: { product: invalid_attributes, store_google_place_id: store.google_place_id }
      end

      it "商品の追加に失敗した場合、エラーメッセージが表示され、newの画面に戻ること" do
        expect(response).to have_http_status(200)
        expect(response.body).to include("商品の追加に失敗しました。")
      end
    end
  end
end
