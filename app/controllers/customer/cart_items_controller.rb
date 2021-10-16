class Customer::CartItemsController < ApplicationController

  before_action :authenticate_customer!

  # カート商品一覧を表示
  def index
    @cart_items = current_customer.cart_items
    @total_price = @cart_items.sum{|cart_item|cart_item.subtotal}
  end

	# 削除や個数を変更した際、カート商品を再計算する
	def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to customers_cart_items_path
	end

	# カート商品を追加する
	def create
	  @genres = Genre.all
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id

    if @cart_item.save
      flash[:notice] = "#{@cart_item.item.name}をカートに追加しました。"
      redirect_to customers_cart_items_path
    else
      flash[:alert] = "個数を選択してください"
      render "customer/items/show"
    end
	end

	# カート商品を空ににする
	def all_destroy
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to customers_cart_items_path
	end

	# カート商品を一つのみ削除
	def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash.now[:alert] = "#{@cart_item.item.name}を削除しました"
    redirect_to customers_cart_items_path
	end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end

end
