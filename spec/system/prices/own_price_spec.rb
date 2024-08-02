require 'rails_helper'

RSpec.describe "Prices::OwnPrices", type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let(:store) { create(:store) }
  let!(:price) { create(:price, google_place_id: store.google_place_id, product_id: product.id, price_value: 500, user: user) }
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit own_prices_path
  end

  it "商品価格投稿履歴が正しく表示されること" do
    expect(page).to have_content("商品価格投稿履歴")
    expect(page).to have_content(store.name)
    expect(page).to have_content(product.name)
    expect(page).to have_content("500")
  end

  it "店舗名のリンクをクリックすると店舗情報ページへ遷移すること" do
    click_link "#{store.name}"
    expect(current_path).to eq(store_path(store.google_place_id))
  end

  it "編集リンクをクリックすると価格編集ページへ遷移すること" do
    click_link "編集"
    expect(current_path).to eq(edit_price_path(price))
  end

  it "削除リンクをクリックすると確認ダイアログが表示され、削除できること" do
    accept_confirm do
      click_link "消去"
    end
    expect(page).to have_content("価格情報を削除しました。")
  end
end
