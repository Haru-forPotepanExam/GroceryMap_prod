require 'rails_helper'

RSpec.describe "Prices::Edits", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:category) { create(:category) }
  let!(:product) { create(:product, category: category) }
  let!(:price) do
    create(:price, product: product, google_place_id: store.google_place_id, user: user, price_value: 100, quantity: 2,
                   weight: 500, memo: "memo")
  end

  before do
    sign_in user
    visit edit_price_path(price, product_id: product.id, google_place_id: store.google_place_id)
  end

  it "各項目に編集する既存の情報が表示されていること" do
    expect(page).to have_field("商品価格:", with: '100')
    expect(page).to have_field("個数：", with: '2')
    expect(page).to have_field("グラム：", with: '500')
    expect(page).to have_field("備考：", with: 'memo')
  end

  it "入力項目を埋めて保存を押すとown_prices_pathに遷移し「価格情報を更新しました」のメッセージが表示されること" do
    fill_in "商品価格:", with: '200'
    fill_in "個数：", with: '3'
    fill_in "グラム：", with: '600'
    fill_in "備考：", with: 'Updated memo'
    click_button '保存'

    expect(current_path).to eq(own_prices_path)
    expect(page).to have_content('価格情報を更新しました')
  end

  it "不正な値を入力した場合、「価格情報の更新に失敗しました」が表示されること" do
    fill_in "商品価格:", with: ''
    click_button '保存'

    expect(page).to have_content('価格情報の更新に失敗しました')
  end
end
