class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites
    @stores = @favorites.map do |fav|
      Client.spot(fav.google_place_id, language: 'ja')
    end
  end

  def create
    @favStore = Store.find_or_initialize_by(google_place_id: params[:store_google_place_id])
    if @favStore.save
      @favorite = current_user.favorites.new(google_place_id: @favStore.google_place_id)
      if @favorite.save
        redirect_to request.referer
      end
    end
  end

  def destroy
    @favStore = Store.find(params[:store_google_place_id])
    @favorite = current_user.favorites.find_by(google_place_id: @favStore.google_place_id)
    @favorite.destroy
    redirect_to request.referer
  end
end
