require 'rails_helper'

RSpec.describe "SessionsControllers", type: :request do
  let(:user) { create(:user) }
  let(:invalid_user_params) { attributes_for(:user, password: "wrongpass") }

  describe "POST /users/sign_in" do
    context "パラメーターが正当な場合" do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end
  
      it "リクエストが成功すること" do
        expect(response).to have_http_status(303)
      end
      it "ログインできること" do
        expect(response).to redirect_to(profile_path)
      end
    end
  
    context "パラメーターが不正な場合" do
      before do
        post user_session_path, params: { user: invalid_user_params }
      end
      it "リクエストが失敗すること" do
        expect(response).not_to have_http_status(303)
      end
      it "エラーが発生すること" do
        expect(response.body).to include("Eメールまたはパスワードが違います。")
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      user.confirm
      sign_in user
      delete destroy_user_session_path
    end

    it "リクエストが成功すること" do
      expect(response).to have_http_status(303)
    end

    it "ログアウトできること" do
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
