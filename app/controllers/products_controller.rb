class ProductsController < ApplicationController
  def index
    @category1 = Product.where(category_id: 1)
    @category2 = Product.where(category_id: 2)
    @category3 = Product.where(category_id: 3)
    @category4 = Product.where(category_id: 4)
    @category5 = Product.where(category_id: 5)
    @category6 = Product.where(category_id: 6)
    @category7 = Product.where(category_id: 7)
    @category8 = Product.where(category_id: 8)

    @store = Client.spot(params[:google_place_id], language: 'ja')
    @google_place_id = @store.place_id
  end

  def new
    @product = Product.new
    session[:previous_url] = store_path(params[:store_google_place_id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "商品を追加しました。"
      redirect_to session[:previous_url]
    else
      flash[:alert] = "商品の追加に失敗しました。"
      render "new"
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :category_id)
  end
end
