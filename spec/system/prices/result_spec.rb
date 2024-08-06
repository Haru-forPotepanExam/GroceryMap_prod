require 'rails_helper'

RSpec.describe "Prices::Results", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:category) { create(:category) }
  let!(:product) { create(:product, category: category) }
  let!(:price) do
    create(:price, google_place_id: store.google_place_id, user: user, product: product, price_value: 1500, memo: "memo")
  end

  before do
    sign_in user
    visit result_path
  end

  it "価格情報が表示されていること" do
    fill_in "q_product_name_or_memo_cont", with: "#{product.name}"
    click_button "検索"

    expect(page).to have_content(product.name)
    expect(page).to have_content("1500円")
    expect(page).to have_content("memo")
  end

  it "価格情報がない場合のメッセージが表示されること" do
    fill_in "q_product_name_or_memo_cont", with: "wrong product"
    click_button "検索"

    expect(page).to have_content("価格情報は投稿されていません")
  end
end
