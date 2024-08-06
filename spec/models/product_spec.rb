require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:category) { create(:category) }
  let(:product) { build(:product, category: category, name: "test_product") }
  let(:wrong_product) { build(:product, category: category, name: "") }

  describe 'validations' do
    context "正しい値の場合" do
      it "正しい値の場合エラーが発生しないこと" do
        expect(product).to be_valid
      end
    end

    context "不正な値の場合" do
      before do
        product.save
      end

      it "nameが重複している場合エラーが発生すること" do
        wrong_product.name = "test_product"
        expect(wrong_product).not_to be_valid
      end

      it "nameが空の場合エラーが発生すること" do
        expect(wrong_product).not_to be_valid
      end
    end
  end
end
