class Api::V1::MerchantsController < ApplicationController   
rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response

    def index
        merchants = Merchant.fetch_merchants(params)
        render json: MerchantSerializer.new(merchants, { params: { count: params[:count], sorted: params[:sorted] } })
    end

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

    def destroy
        Merchant.find(params[:id]).destroy
    end
   
    def create
        merchant =  Merchant.create(merchant_params)
        render json: MerchantSerializer.new(merchant)
    end  

    def find_one
        merchant = Merchant.find_one_by_name(params)
        render json: MerchantSerializer.new(merchant)
    end

    private
        
    def merchant_params
    params.require(:merchant).permit(:name)
    end

    def not_found_error_response(error)
        render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404))
        .serialize_json, status: :not_found
    end
end