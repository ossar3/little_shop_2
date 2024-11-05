class Api::V1::ItemMerchantsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response

    def index
       item =Item.find(params[:id])
       merchant = item.merchant
       render json: MerchantSerializer.new(merchant)
    end

    private
    
    def not_found_error_response(error)
        render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: :not_found
    end

end