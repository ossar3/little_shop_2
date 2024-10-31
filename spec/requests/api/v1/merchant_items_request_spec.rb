require 'rails_helper'

RSpec.describe "Item_merchants", type: :request do
    before(:each) do
        @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)
        @merchant_2 = Merchant.create!(name: "Test Merchant 2", created_at: 2.seconds.ago)

    
        @item_1 = Item.create!(name: "Precision Scale", description: "Weighs", unit_price:100.91 , merchant: @merchant_1)
        @item_2 = Item.create!(name: "Digital Thermometer", description: "Reads temperature", unit_price:300.23 , merchant: @merchant_2)
        @item_3 = Item.create!(name: "Silicone Baking Mat", description: "Non-stick magic", unit_price:20.23 , merchant: @merchant_2)
    end

    it "can give the items for a given merchant" do
        id = @merchant_2[:id]

        get "/api/v1/merchants/#{id}/items"

        items = JSON.parse(response.body, symbolize_names: true)
        #binding.pry
        expect(response.status).to eq(200)
        expect(items[:data].count).to eq(2)
        expect(items[:data][0][:id]).to eq(@item_2.id.to_s)
        expect(items[:data][1][:id]).to eq(@item_3.id.to_s)

    end
end