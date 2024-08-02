require 'rails_helper'

RSpec.describe "Prices::OwnResults", type: :system do
  let(:user) { create(:user) }
  let(:favorite_store) { create(:store) }
  let(:category) { create(:category) }
  let!(:product) { create(:product, category: category) }
  let!(:favorite) { create(:favorite, google_place_id: favorite_store.google_place_id, user: user) }
  let!(:price) do
    create(:price, google_place_id: favorite_store.google_place_id, product_id: product.id, price_value: 1000, memo: "memo",
                   user: user)
  end

  before do
    sign_in user
    visit own_prices_result_prices_path
  end

  it "お気に入り店舗の検索結果が正しく表示されること" do
    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
      click_button "検索"
    end

    expect(page).to have_content(product.name)
    expect(page).to have_content("1000円")
    expect(page).to have_content("memo")
  end

  it "価格情報が存在しない場合、メッセージが表示されること" do
    price.destroy
    visit own_prices_result_prices_path

    within(".table_container") do
      fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
      click_button "検索"
    end

    expect(page).to have_content("価格情報は投稿されていません")
  end
end
