require 'rails_helper'

RSpec.describe "Prices Index", type: :system do
  let(:user) { create(:user) }
  let!(:store) { create(:store) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let!(:price) do
    create(:price,
    product: product,
    google_place_id: store.google_place_id,
    user: user,
    price_value: 500,
    quantity: 1,
    weight: 200,
    memo: "memo",
    created_at: Time.current)
  end
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit store_prices_path(product_id: product.id, store_google_place_id: store.google_place_id)
  end

  it "商品と店舗名が正しく表示されていること" do
    expect(page).to have_content(store.name)
    expect(page).to have_content(product.name)
  end

  it "価格情報が正しく表示されていること" do
    within(".table_container") do
      expect(page).to have_content(price.created_at.to_s(:datetime_jp))
      expect(page).to have_content("#{price.price_value}円")
      expect(page).to have_content("#{price.prices_per_gram}円/100g")
      expect(page).to have_content("#{price.prices_per_quantity}円/1個")
      expect(page).to have_content(price.memo)
    end
  end
end
