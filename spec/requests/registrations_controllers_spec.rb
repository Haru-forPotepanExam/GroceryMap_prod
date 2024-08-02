require 'rails_helper'

RSpec.describe "RegistrationsControllers", type: :request do
  let(:user) { create(:user) }
  let(:user_params) { attributes_for(:user) }
  let(:invalid_name_params) { attributes_for(:user, name: "") }
  let(:update_user_params) { attributes_for(:user, email: "update@gmail.com", current_password: user.password) }
  let(:invalid_update_user_params) { attributes_for(:user, email: "update@gmail.com", current_password: "") }

  describe "POST /users" do
    context "パラメーターが正当な場合" do
      before do
        post user_registration_path, params: { user: user_params }
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(303)
      end

      it "認証メールが送信されること" do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end

      it "ユーザーが作成されること" do
        expect(User.count).to eq(1)
      end

      it "ホームに戻ること" do
        expect(response).to redirect_to(root_path)
      end
    end

    context "パラメーターが不正な場合" do
      context "名前が不正な場合" do
        before do
          post user_registration_path, params: { user: invalid_name_params }
        end

        it "リクエストが失敗すること" do
          expect(response).not_to have_http_status(303)
        end

        it "認証メールが送信されないこと" do
          expect(ActionMailer::Base.deliveries.size).to eq(0)
        end

        it "ユーザーが作成されないこと" do
          expect(User.count).to eq(0)
        end

        it "エラーが発生すること" do
          expect(response.body).to include "エラーが発生したため ユーザー は保存されませんでした。"
        end
      end
    end
  end

  describe "PUT /users" do
    before do
      user.confirm
      sign_in user
    end

    context "現在のパスワードが入力されている場合" do
      before do
        put user_registration_path, params: { user: update_user_params }
        user.reload
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(303)
      end

      it "認証メールが送信されること" do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end

      it "認証待ちのメールアドレスが追加されること" do
        user.reload
        expect(user.unconfirmed_email).to eq("update@gmail.com")
      end

      it "プロフィール画面にリダイレクトされること" do
        expect(response).to redirect_to(profile_path)
      end
    end

    context "現在のパスワードが入力されていない場合" do
      before do
        put user_registration_path, params: { user: invalid_update_user_params }
      end

      it "リクエストが失敗すること" do
        expect(response).not_to have_http_status(303)
      end

      it "認証メールが送信されないこと" do
        expect(ActionMailer::Base.deliveries.size).to eq(0)
      end

      it "メールアドレスが更新されないこと" do
        user.reload
        expect(user.email).not_to eq("update@gmail.com")
      end

      it "エラーが発生すること" do
        expect(response.body).to include "エラーが発生したため ユーザー は保存されませんでした。"
      end
    end
  end

  describe "DELETE /users" do
    context "サインインしている状態の場合" do
      before do
        user.confirm
        sign_in user
        delete user_registration_path
      end

      it "リクエストが成功すること" do
        expect(response).to have_http_status(303)
      end

      it "ユーザーが削除されていること" do
        expect(User.count).to eq(0)
      end

      it "ルートパスにリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "サインアウトしている状態の場合" do
      before do
        sign_out user
        delete user_registration_path
      end

      it "リクエストが失敗すること" do
        expect(response).not_to have_http_status(303)
      end

      it "アカウントが削除されないこと" do
        expect(User.count).to eq(1)
      end

      it "サインイン画面にリダイレクトされること" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
