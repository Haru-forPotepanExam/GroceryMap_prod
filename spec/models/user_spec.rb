require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user, email: "test@gmail.com", name: "test") }
  let(:wrong_user) { build(:user, email: "test2@gmail.com", name: "test2") }

  describe 'validations' do
    context "正しい値の場合" do
      it "エラーが発生しないこと" do
        expect(user).to be_valid
      end
    end

    context "不正な値の場合" do
      it "emailが重複する場合エラーが発生すること" do
        wrong_user.email = "test@gmail.com"
        expect(wrong_user).not_to be_valid
      end

      it "nameが空の場合、場合エラーが発生すること" do
        wrong_user.name = ""
        expect(wrong_user).not_to be_valid
      end

      it "nameが重複する場合エラーが発生すること" do
        wrong_user.name = "test"
        expect(wrong_user).not_to be_valid
      end
    end
  end
end
