require 'rails_helper'

RSpec.describe Store, type: :model do
  let(:store) { create(:store) }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:favorite) { create(:favorite, google_place_id: store.google_place_id, user: user) }

  describe 'favorited_by?' do
    context 'ユーザーがお気に入りした場合' do
      it 'returns true' do
        expect(store.favorited_by?(user)).to be true
      end
    end

    context 'ユーザーがお気に入りしていない場合' do
      it 'returns false' do
        expect(store.favorited_by?(other_user)).to be false
      end
    end
  end
end
