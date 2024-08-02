class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites
    @stores = @favorites.map do |fav|
      Client.spot(fav.google_place_id, language: 'ja')
    end
  end

  def create
    @fav_store = Store.find_or_initialize_by(google_place_id: params[:store_google_place_id])
    if @fav_store.save
      @favorite = current_user.favorites.new(google_place_id: @fav_store.google_place_id)
      if @favorite.save
        redirect_to store_path(@fav_store)
      end
    end
  end

  def destroy
    @fav_store = Store.find(params[:store_google_place_id])
    @favorite = current_user.favorites.find_by(google_place_id: @fav_store.google_place_id)
    @favorite.destroy
    redirect_to store_path(@fav_store)
  end
end
