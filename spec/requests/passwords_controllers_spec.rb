require 'rails_helper'

RSpec.describe "PasswordsControllers", type: :request do
  let(:user) { create(:user) }

  describe "POST /users/password" do
    before do
      post user_password_path, params: { user: { email: user.email } }
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(303)
    end

    it "パスワードリセットメールが送信されること" do
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end

  describe "PUT /users/password" do
    before do
      token = user.send_reset_password_instructions
      @reset_password_token = token
      put user_password_path,
params: { user: { reset_password_token: @reset_password_token, password: "newpassword", password_confirmation: "newpassword" } }
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(303)
    end

    it "パスワードが変更されること" do
      expect(user.reload.valid_password?("newpassword")).to be true
    end
  end
end
