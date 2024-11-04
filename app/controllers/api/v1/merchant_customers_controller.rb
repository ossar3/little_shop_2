class Api::V1::MerchantCustomersController < ApplicationController
    before_action :validate_merchant, only: [:index]

    def index
        customers = Customer.show_all_customers(params[:id])
        render json: CustomerSerializer.new(customers)
    end




    private


    def validate_merchant
        merchant = Merchant.find_by(id: params[:id])
        if merchant == nil
            error_message = ErrorMessage.new("Merchant not found", 404)
            render json: ErrorSerializer.new(error_message).serialize_json, status: :not_found
        end
    end
end
class Api::V1::MerchantCustomersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response

    def index
        customers = Customer.show_all_customers(params[:id])
        render json: CustomerSerializer.new(customers)
    end




    private

    def not_found_error_response(error)
        render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404))
        .serialize_json, status: :not_found
    end
end