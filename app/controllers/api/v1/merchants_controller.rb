class Api::V1::MerchantsController < ApplicationController    

    def index
        merchants = Merchant.all
        render json: MerchantSerializer.new(merchants)
    end

    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def destroy
        Merchant.find(params[:id]).destroy
    end
   
    def create
        merchant =  Merchant.create(merchant_params)
        render json: MerchantSerializer.new(merchant)
    end  


    private
        
    def merchant_params
    params.require(:merchant).permit(:name)
    end
end