require 'rails_helper'

RSpec.describe "Prices::News", type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let(:store) { create(:store) }
  let(:google_place_id) { store.google_place_id }
  let(:mock_store) do
    OpenStruct.new(
      place_id: google_place_id,
      name: store.name,
      formatted_address: "123 Tokyo St",
      opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] }
    )
  end

  before do
    allow(Client).to receive(:spot).with(google_place_id, language: 'ja').and_return(mock_store)
  end

  context "ログインしている場合" do
    before do
      sign_in user
      visit new_store_price_path(store_google_place_id: google_place_id, product_id: product.id)
    end

    it "価格情報投稿ページが正しく表示されること" do
      expect(page).to have_content("#{mock_store.name} の #{product.name} の価格情報を投稿する")
      expect(page).to have_field("商品価格（円）:")
      expect(page).to have_field("個数（個）：")
      expect(page).to have_field("グラム（g）：")
      expect(page).to have_field("備考：")
    end

    it "価格情報が正しく投稿できること" do
      fill_in "商品価格（円）:", with: 300
      fill_in "個数（個）：", with: 3
      fill_in "グラム（g）：", with: 200
      fill_in "備考：", with: "memo"

      click_button "送信"

      expect(current_path).to eq(store_prices_path(store_google_place_id: google_place_id))
      expect(page).to have_content("商品価格を投稿しました")
    end

    it "価格情報が投稿できなかった場合、エラーメッセージが表示されること" do
      fill_in "商品価格（円）:", with: ""
      fill_in "個数（個）：", with: 3
      fill_in "グラム（g）：", with: 200
      fill_in "備考：", with: "memo"

      click_button "送信"

      expect(page).to have_content("投稿に失敗しました")
    end
  end

  context "ログインしていない場合" do
    before do
      visit new_store_price_path(store_google_place_id: google_place_id, product_id: product.id)
    end

    it "ログインが必要なメッセージが表示されること" do
      expect(page).to have_content("価格情報の投稿にはログインが必要です")
    end
  end
end
