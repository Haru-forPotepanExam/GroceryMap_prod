require 'rails_helper'

RSpec.describe "User Registrations", type: :system do
  before do
    visit new_user_registration_path
  end

  it "ユーザーネーム、Eメール、パスワード、パスワード（確認用）を入力後にアカウント登録をクリック時、ルートに戻り確認メールが送信されること" do
    fill_in 'ユーザーネーム', with: 'Test'
    fill_in 'Eメール', with: 'test@gmail.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_button 'アカウント登録'

    expect(page).to have_current_path(root_path)
    expect(page).to have_content('本人確認用のメールを送信しました')
  end

  it "ログインをクリック時にログイン画面に遷移すること" do
    within(".user_container") do
      click_link 'ログイン'
    end
    expect(page).to have_current_path(new_user_session_path)
  end

  it "アカウント確認のメールを受け取っていませんか？をクリック時にアカウント確認メール再送画面に遷移すること" do
    click_link "アカウント確認のメールを受け取っていませんか？"
    expect(page).to have_current_path(new_user_confirmation_path)
  end
end
