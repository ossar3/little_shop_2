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