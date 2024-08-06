require 'rails_helper'

RSpec.describe Price, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let(:store) { create(:store) }
  let(:price) do
    build(
      :price,
      user: user,
      product: product,
      google_place_id: store.google_place_id,
      price_value: 500,
      quantity: 2,
      weight: 300,
      memo: 'memo'
    )
  end

  context "priceが正しい場合" do
    it 'price' do
      expect(price).to be_valid
    end
  end

  context "priceが正しくない場合" do
    it "price_valueが数字ではない場合エラーが発生すること" do
      price.price_value = nil
      expect(price).not_to be_valid
    end

    it "price_valueが空の時エラーが発生すること" do
      price.price_value = 12.34
      expect(price).not_to be_valid
    end

    it "quantity_or_weightがどちらも空な時エラーが発生すること" do
      price.quantity = nil
      price.weight = nil
      expect(price).not_to be_valid
    end

    it "weight_validityが文字の場合エラーが発生すること" do
      price.weight = "テスト"
      expect(price).not_to be_valid
    end

    it "weight_validityが100未満の場合エラーが発生すること" do
      price.weight = 1
      expect(price).not_to be_valid
    end

    it "quantity_validityが文字の場合エラーが発生すること" do
      price.quantity = "テスト"
      expect(price).not_to be_valid
    end

    it "quantity_validityが1未満の場合エラーが発生すること" do
      price.quantity = 0
      expect(price).not_to be_valid
    end

    it "memo" do
      price.memo = 'a' * 160
      expect(price).not_to be_valid
    end
  end

  it 'prices per gram' do
    expect(price.prices_per_gram).to eq((500 / 300 * 100).round)
  end

  it 'prices per quantity' do
    expect(price.prices_per_quantity).to eq((500 / 2).round)
  end
end
