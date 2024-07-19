require 'rails_helper'

RSpec.describe "User Edit", type: :system do
  let(:user) { create(:user) }
  before do
    sign_in user
    visit edit_user_registration_path(user)
  end

  it "アカウント編集をクリックするとアカウント情報編集画面に遷移すること" do
    click_link 'アカウント編集'
    expect(page).to have_current_path(edit_user_registration_path)
  end

  it "プロフィールをクリックするとプロフィール画面が表示されること" do
    click_link 'プロフィール'
    expect(page).to have_current_path(profile_path)
  end

  it "現在のユーザーネームが表示されていること" do
    expect(find('#user_name').value).to eq(user.name)
  end

  it "現在のメールアドレスが表示されていること" do
    expect(find('#user_email').value).to eq(user.email)
  end

  it "Eメールと現在のパスワードを入力し更新をクリックした際に、確認用メールが送信されること" do
    fill_in 'Eメール', with: 'newemail@gmail.com'
    fill_in '現在のパスワード', with: user.password
    click_button '更新'

    expect(page).to have_current_path(profile_path)
    expect(page).to have_content('確認メールを送信しました')
  end

  it "パスワードと確認用パスワードを入力し更新をクリックした際に、パスワードが更新されること" do
    fill_in 'パスワード', with: 'newpassword123'
    fill_in 'パスワード（確認用）', with: 'newpassword123'
    fill_in '現在のパスワード', with: 'password'
    click_button '更新'

    expect(page).to have_current_path(profile_path)
    expect(page).to have_content('アカウント情報を変更しました')
  end
end
