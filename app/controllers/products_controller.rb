class ProductsController < ApplicationController
  before_action :find_product, only: [:edit, :destroy]
  before_action :find_current_user_product, only: [:update, :toggle_publish,:favorite]
  before_action :session_required
  before_action :store_pundit, only: [:index, :new, :create]

  def index
    @products = current_user.store_profile.products.available.order(id: :desc)
    @productsUnavailable = current_user.store_profile.products.unavailable.order(id: :desc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = current_user.store_profile.products.new(params_product)
    
    if @product.save
      redirect_to store_profiles_path, notice: "新增餐點成功"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(params_product)
      redirect_to product_path(@product), notice: '編輯餐點成功'
    else
      render :edit
    end
  end

  def destroy
    @product.destroy if @product
    redirect_to products_path, notice: '刪除餐點成功'
  end

  def toggle_publish
    authorize @product, :publish?
    if @product.may_publish?
      @product.publish!
      redirect_to products_path, notice: '餐點已上架'
    elsif @product.may_delist?
      @product.delist!
      redirect_to products_path, notice: '餐點已下架'
    end
  end

  private
  def params_product
    params.require(:product).permit(:name, :price, :description)
  end

  def find_product
    @product = Product.find_by!(id: params[:id])
  end

  def find_current_user_product
    @product = current_user.store_profile.products.find_by!(id: params[:id])
  end

  def find_user_id
    @user = User.find_by!(id: params[:user_id])
  end

  def store_pundit
    authorize current_user, :start_business
  end
end