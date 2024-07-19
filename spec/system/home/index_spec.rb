require 'rails_helper'

RSpec.describe "Home", type: :system do
  before do
    visit root_path
  end

  it "テスト" do
    expect(page).to have_content('食料品')
  end
end
