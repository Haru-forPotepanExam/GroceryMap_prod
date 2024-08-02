require 'rails_helper'

RSpec.describe "Home", type: :system do
  let(:mock_store) do
    OpenStruct.new(place_id: "test_google_place_id1", name: "sample_store", formatted_address: "123 Tokyo St",
                   opening_hours: { 'weekday_text' => ["Monday: 9:00 AM – 9:00 PM"] })
  end

  before do
    allow(Client).to receive(:spot).and_return(mock_store)
    visit root_path
  end

  it "renderにて呼び出した画面が表示されていること" do
    expect(page).to have_content("ストアを検索")
  end

  it "検索バーが表示されること" do
    expect(page).to have_field("autocomplete", placeholder: "店名、または最寄りの駅名を入力してください")
    expect(page).to have_css("#map")
  end
end
