class Admin::ProductsController < Admin::BaseController
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:info] = "Congrats! #{@product.name} created!"
      redirect_to admin_dashboard_path
    else
      flash.now[:alert] = "Sorry, boss lolololololololol.  Something went wrong :(... Please try again."
      render :new
    end
  end

  def index
    # if params[:active] = true
    # do some query in the params to distinquish between active/inactive
    @products = Product.active_index
  end

  def inactive_index
    @products = Product.inactive_index
  end

  def update
    @product = Product.find(params[:id])
    status = @product.inactive?
    if @product.update(product_params)
      if status == true && status == @product.inactive?
        flash[:alert] = "Sorry mate! Reactivate the product!"
        return redirect_to admin_inactive_products_path
      elsif status == true
        flash[:info] = "#{@product.name} has been activated"
        return redirect_to admin_inactive_products_path
      elsif @product.inactive?
        flash[:alert] = "#{@product.name} has been deactivated"
      else
        flash[:info] = "Congrats! #{@product.name} has been updated!"
      end
      redirect_to admin_products_path
    else
      flash.now[:alert] = "Sorry, boss lolololololololol.  Something went wrong :(... Please try again."
      render :new
    end
  end

private

  def product_params
    params.require(:product).permit(:name, :price, :description, :image, :sale, :sale_price, :category_id, :inactive)
  end
end
