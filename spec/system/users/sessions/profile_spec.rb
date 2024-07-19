require 'rails_helper'

RSpec.describe "User Profile", type: :system do
  let(:user) { create(:user) }
  before do
    sign_in user
    visit profile_path(user)
  end

  it "アカウント編集をクリックするとアカウント情報編集画面に遷移すること" do
    click_link 'アカウント編集'
    expect(page).to have_current_path(edit_user_registration_path)
  end

  it "プロフィールをクリックするとプロフィール画面が表示されること" do
    click_link 'プロフィール'
    expect(page).to have_current_path(profile_path)
  end

  it "ユーザー名が表示されること" do
    expect(page).to have_content(user.name)
  end

  it "メールアドレスが表示されること" do
    expect(page).to have_content(user.email)
  end
end
