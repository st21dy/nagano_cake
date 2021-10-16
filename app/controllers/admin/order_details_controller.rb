class Admin::OrderDetailsController < ApplicationController
  
  before_action :authenticate_admin!

  def update
  		@order_detail = OrderDetail.find(params[:id])
  		# 注文商品からの注文テーブルの呼び出し
  		@order = @order_detail.order
  		# 制作ステータスの更新
		  if @order_detail.update(order_detail_params)
		  	flash[:success] = "制作ステータスを変更しました"
		    redirect_to admin_order_path(@order_detail.order)
		  else
		     render "show"
		  end
		  
		  if @order_detail.making_status == "製作中" #製作ステータスが「製作作中」なら入る
		    @order.update(status: 2) #注文ステータスを「製作中」　に更新
		    
		    #上記の条件に当てはまらなければ、商品の個数の特定　　　　製作ステータスが「製作l完了」の商品をカウント
		    #数が一致すれば、全ての商品の製作ステータスが「製作完了」だとわかる
		  elsif @order.order_details.count ==  @order.order_details.where(making_status: "製作完了").count
			  @order.update(status: 3) #注文ステータスを「発送準備中]に更新
		  end
		  
  end

  private
  def order_detail_params
		  params.require(:order_detail).permit(:making_status)
  end
	
	
end
