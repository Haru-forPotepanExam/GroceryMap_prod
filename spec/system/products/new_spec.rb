require 'rails_helper'

RSpec.describe "Products::News", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let!(:category) { create(:category, id: 1) }
  let(:product) { build(:product, category: category) }
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    allow(Client).to receive(:spot).and_return(mock_store)
  end

  context "ログインしている場合" do
    before do
      sign_in user
      visit new_product_path(store_google_place_id: store.google_place_id)
    end

    it "商品を追加するためのフォームが表示されていること" do
      expect(page).to have_content("商品を追加する")
      expect(page).to have_select("カテゴリー",
options: ["選択してください", "野菜", "穀物（米・シリアル等）", "水産物", "畜産物(肉)", "卵・乳製品・大豆製品", "果物", "粉類", "その他"])
      expect(page).to have_field("商品名")
      expect(page).to have_button("投稿")
    end

    it "各項目を入力後正常に保存されること" do
      select "野菜", from: "カテゴリー"
      fill_in "商品名", with: "キャベツ"
      click_button "投稿"

      expect(page).to have_content("商品を追加しました。")
    end

    it "十分に項目が埋まっていない場合、エラーが発生すること" do
      click_button "投稿"

      expect(page).to have_content("商品の追加に失敗しました。")
    end
  end

  context "ログインしていない場合" do
    it "ログインが必要な旨が表示されること" do
      visit new_product_path(store_google_place_id: store.google_place_id)
      expect(page).to have_content("商品情報の投稿にはログインが必要です。")
    end
  end
end
