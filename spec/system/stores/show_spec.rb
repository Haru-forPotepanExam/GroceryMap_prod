require 'rails_helper'

RSpec.describe "Stores::Shows", type: :system do
  let(:user) { create(:user) }
  let(:store) { create(:store) }
  let(:mock_store) do
    OpenStruct.new(place_id: store.google_place_id, name: store.name, formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    sign_in user
    allow(Client).to receive(:spot).and_return(mock_store)
    visit store_path(store)
  end

  it "ストア情報が表示されていること" do
    expect(page).to have_content(mock_store.name)
    expect(page).to have_content(mock_store.formatted_address)
    expect(page).to have_content(mock_store.formatted_phone_number)
    expect(page).to have_content("Monday: 9:00 AM – 9:00 PM")
  end

  it "お気に入りボタンが表示されていること" do
    expect(page).to have_css(".fav_btn")
  end

  it "パーシャルが正常に表示されていること" do
    expect(page).to have_css(".product_container")
  end
end
