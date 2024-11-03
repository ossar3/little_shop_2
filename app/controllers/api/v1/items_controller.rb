class Api::V1::ItemsController < ApplicationController

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
end


