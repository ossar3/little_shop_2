class Api::V1::ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_response
before_action :validate_price_params, only: [:find_all]
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
        items = Item.find_all_items(params)
        if items.nil?
            render json:    
            { data: {}    
            }
        else
        render json: ItemSerializer.new(items)
        end
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

    def validate_price_params
        if (params[:max_price].present? && params[:max_price].to_f < 0)|| (params[:min_price].present? && params[:min_price].to_f < 0)
            render json:    {
                errors: [
                  {
                    status: "400",
                    message: "Invalid parameters"
                  }
                ]
              },
              status: :bad_request
        end
        if params[:name].present? && (params[:min_price].present? || params[:max_price].present?)
            render json:    {
                errors: [
                    {
                    status: "400",
                    message: "Invalid parameters"
                    }
                ]
                },
                status: :bad_request
        end
    end
end


