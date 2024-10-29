class Api::V1::MerchantsController < ApplicationController    
    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def create
        merchant =  Merchant.create(merchant_params)
        render json: MerchantSerializer.new(merchant)
    end
end

private

def merchant_params
    params.require(:merchant).permit(:name)
end