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
end