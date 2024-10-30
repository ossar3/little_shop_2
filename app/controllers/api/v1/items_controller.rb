class Api::V1::ItemsController < ApplicationController

    def index
        items = Item.all
        render json: ItemSerializer.new(items)
    end

    def show
        item = Item.find(params[:id])
        render json: ItemSerializer.new(item)
    end

    def destroy
        Item.find(params[:id]).destroy
    end

    def create
        item = Item.new(item_params)
        render json: ItemSerializer.new(item)
    end


    private 

    def item_params
        params.require(:item).permit( :merchant_id,:unit_price, :name, :description)
    end
end


