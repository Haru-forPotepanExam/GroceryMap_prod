require 'rails_helper'

RSpec.describe "User Sign in", type: :system do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  it "Eメールとパスワードを入力しログインボタンクリック時にログインできること" do
    within(".user_container") do
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end
    expect(page).to have_content 'ログインしました'
  end

  it "アカウント登録ボタンをクリック時にアカウント新規登録画面に遷移すること" do
    click_link "アカウント登録"
    expect(page).to have_current_path(new_user_registration_path)
  end

  it "パスワードを忘れましたか？のボタンをクリック時にパスワード再設定の画面に遷移すること" do
    click_link "パスワードを忘れましたか？"
    expect(page).to have_current_path(new_user_password_path)
  end

  it "アカウント確認のメールを受け取っていませんか？をクリック時にアカウント確認メール再送画面に遷移すること" do
    click_link "アカウント確認のメールを受け取っていませんか？"
    expect(page).to have_current_path(new_user_confirmation_path)
  end
end
