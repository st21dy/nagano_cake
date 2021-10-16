class Customer::AddressesController < ApplicationController

  before_action :authenticate_customer!


  
   # 配送先一覧/配送先登録画面
    def index
        @shipping_address = Address.new
        @shipping_addresses = current_customer.address
    end

    # 配送先登録ボタン
    def create
        @shipping_address = Address.new(address_params)
        @shipping_address.customer_id = current_customer.id
        if @shipping_address.save
            redirect_to customers_addresses_path
            flash[:success] = "登録しました。"
        else
            @shipping_address = Address.new
            @shipping_addresses = current_customer.addresses
            render 'index'
        end
    end

    # 配送先を削除する
    def destroy
        shipping_address = Address.find(params[:id])
        shipping_address.destroy
        redirect_to customers_addresses_path
    end 

    # 配送先編集ボタン
    def edit
        @shipping_address = Address.find(params[:id])
    end

    # 配送先編集保存ボタン
    def update
        shipping_address = Address.find(params[:id])
        shipping_address.update(address_params)
        redirect_to customers_addresses_path
    end

    private
    def address_params
        params.require(:address).permit(:customer_id, :name, :postal_code, :address)
    end

end