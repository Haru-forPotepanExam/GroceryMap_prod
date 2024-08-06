require 'rails_helper'

RSpec.describe "Favorites Index", type: :system do
  let(:user) { create(:user) }
  let!(:favorite_store) { create(:store, name: "favorite_store", google_place_id: "favorite_store_id") }
  let!(:unfavorite_store) { create(:store, name: "unfavorite_store", google_place_id: "unfavorite_store_id") }
  let!(:favorite) { create(:favorite, user: user, google_place_id: favorite_store.google_place_id) }
  let(:mock_store) do
    OpenStruct.new(place_id: favorite_store.google_place_id, name: "favorite_store", formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit my_stores_favorites_path
  end

  it "お気に入りした店舗名が表示されていること" do
    expect(page).to have_content(favorite_store.name)
  end

  it "お気に入りした店舗以外の店舗名が表示されていないこと" do
    expect(page).not_to have_content(unfavorite_store.name)
  end

  it "お気に入りした店舗情報のうち、nameをクリックすると店舗情報詳細画面へ遷移すること" do
    click_link 'favorite_store'
    expect(current_path).to eq(store_path(favorite.google_place_id))
  end
end
