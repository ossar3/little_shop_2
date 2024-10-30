class Api::V1::MerchantsController < ApplicationController    
    def show
        merchant = Merchant.find(params[:id])
        render json: MerchantSerializer.new(merchant)
    end

    def update
        merchant = Merchant.find(params[:id])
        if merchant.update(merchant_params)
            render json: MerchantSerializer.new(merchant), status: :ok
        end
    end

    private

    def merchant_params
        params.require(:merchant).permit(:name)
    end
end