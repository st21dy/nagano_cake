class Admin::OrdersController < ApplicationController
  
  before_action :authenticate_admin!

  def index
  		@orders = Order.all.page(params[:page]).per(10)
  end

  def current_index
    @orders = Order.where(customer_id: params[:id]).page(params[:page]).per(10)
    render :index
  end

  def today_order_index
    now = Time.current
    @orders = Order.where(created_at: now.all_day).page(params[:page]).per(10)
    render :index
  end

	def show
		# 注文内容の情報を取得
		@order = Order.find(params[:id])
		# 注文内容の商品を取得
		@order_details = @order.order_details
		
		@total = 0
	end

	def update
		# 注文詳細の特定
		@order = Order.find(params[:id])
		# 注文から紐付く商品の取得
		@order_details = @order.order_details
		# 注文ステータスの更新
		if @order.update(order_params)
		   flash[:success] = "注文ステータスを変更しました"
		   redirect_to admin_order_path(@order)
		else
		   render "show"
		end
		if @order.status == "入金確認" #注文ステータスが入金確認なら下の事をする
	     @order_details.update_all(making_status: 1) #製作ステータスを「製作待ちに」　更新
		end
	end

	private
	def order_params
		  params.require(:order).permit(:status)
	end
	
end
