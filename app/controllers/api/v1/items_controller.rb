class Api::V1::ItemsController < ApplicationController
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

    private

    def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end
end