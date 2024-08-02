require 'rails_helper'

RSpec.describe "Products Index", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:category1) { create(:category, id: 1) }
  let(:category2) { create(:category, id: 2) }
  let!(:vegetable_product) { create(:product, name: "キャベツ", category: category1) }
  let!(:grain_product) { create(:product, name: "シリアル", category: category2) }
  let!(:vegetable_price) do
    create(:price, product: vegetable_product, price_value: 100, google_place_id: store.google_place_id, user: user)
  end
  let!(:grain_price) do
    create(:price, product: grain_product, price_value: 200, google_place_id: store.google_place_id, user: user)
  end
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit products_path(google_place_id: store.google_place_id)
  end

  it "商品一覧が表示されていること" do
    within(".test_category1") do
      expect(page).to have_content("キャベツ")
      expect(page).to have_content("100")
      expect(page).to have_link("商品価格を確認する",
href: store_prices_path(store_google_place_id: store.google_place_id, product_id: vegetable_product.id))
      expect(page).to have_link("商品価格を投稿する",
href: new_store_price_path(store_google_place_id: store.google_place_id, product_id: vegetable_product.id))
    end

    within(".test_category2") do
      expect(page).to have_content("シリアル")
      expect(page).to have_content("200")
      expect(page).to have_link("商品価格を確認する",
href: store_prices_path(store_google_place_id: store.google_place_id, product_id: grain_product.id))
      expect(page).to have_link("商品価格を投稿する",
href: new_store_price_path(store_google_place_id: store.google_place_id, product_id: grain_product.id))
    end
  end

  it "価格情報がない場合のメッセージが表示されること" do
    grain_price.destroy
    visit products_path(google_place_id: store.google_place_id)

    within(".test_category2") do
      expect(page).to have_content("価格情報なし")
    end
  end

  it "ページトップに戻るリンクが表示されていること" do
    expect(page).to have_link("ページトップに戻る", href: "#product_top")
  end

  it "商品を追加するリンクが表示されていること" do
    expect(page).to have_link("商品を追加する", href: new_product_path(store_google_place_id: store.google_place_id))
  end

  it "商品価格を確認するリンクをクリックして正しいページに遷移すること" do
    within(".test_category1") do
      click_link "商品価格を確認する"
    end

    expect(page).to have_current_path(store_prices_path(store_google_place_id: store.google_place_id,
                                                        product_id: vegetable_product.id))
  end

  it "商品価格を投稿するリンクをクリックして正しいページに遷移すること" do
    within(".test_category1") do
      click_link "商品価格を投稿する"
    end

    expect(page).to have_current_path(new_store_price_path(store_google_place_id: store.google_place_id,
                                                           product_id: vegetable_product.id))
  end

  it "商品を追加するリンクをクリックして正しいページに遷移すること" do
    click_link "商品を追加する"

    expect(page).to have_current_path(new_product_path(store_google_place_id: store.google_place_id))
  end
end
