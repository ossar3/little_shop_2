class Api::V1::ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response
rescue_from ActionController::ParameterMissing, with: :bad_request_error_response
rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error
    def index
        items = fetch_items
        render json: ItemSerializer.new(items)
    end

    def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item)
    end

    def update
  item = Item.find(params[:id])

  if item.update(item_params)
    render json: ItemSerializer.new(item), status: :ok
  else
    record_invalid_error_response(item)
  end
end

    def destroy
        Item.find(params[:id]).destroy
    end

    def create
        item = Item.new(item_params)
        render json: ItemSerializer.new(item)
    end

    def find_all
        if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
            render json: {
                error: "Cannot have name and price parameters"
            }
        end
        
        items = Item.find_all_items(params)
        render json: ItemSerializer.new(items)
    end

    private 

    def fetch_items
        params[:sorted].presence == 'price' ? Item.sorted_by_price : Item.all
    end

    def item_params
        params.require(:item).permit( :merchant_id,:unit_price, :name, :description)
    end

    def not_found_error_response(error)
        render json: ErrorSerializer.new(ErrorMessage.new(error.message, 404)).serialize_json, status: :not_found
    end
    
    def bad_request_error_response(error)
        render json: ErrorSerializer.new(ErrorMessage.new(error.message, 400)).serialize_json, status: :bad_request
    end

    def handle_parse_error(error)
        render json: ErrorSerializer.new(ErrorMessage.new("Invalid JSON format", 400)).serialize_json, status: :bad_request
    end

    def record_invalid_error_response(item)
        render json: ErrorSerializer.new(ErrorMessage.new(item.errors.full_messages.join(', '), 422)).serialize_json, status: :unprocessable_entity
    end
end


