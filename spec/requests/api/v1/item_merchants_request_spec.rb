require 'rails_helper'

RSpec.describe "Item_merchants", type: :request do
    before(:each) do
        @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)
        @merchant_2 = Merchant.create!(name: "Test Merchant 2", created_at: 2.seconds.ago)
        @merchant_3 = Merchant.create!(name: "Test Merchant 3", created_at: 1.seconds.ago)
    
        @item_1 = Item.create!(name: "Precision Scale", description: "Weighs", unit_price:100.91 , merchant: @merchant_1)
        @item_2 = Item.create!(name: "Digital Thermometer", description: "Reads temperature", unit_price:300.23 , merchant: @merchant_2)
        @item_3 = Item.create!(name: "Silicone Baking Mat", description: "Non-stick magic", unit_price:20.23 , merchant: @merchant_3)
    end

    it "can give the merchant of a selected item" do
     
        id = @item_1[:id]

        get "/api/v1/items/#{id}/merchant"

        merchant = JSON.parse(response.body,symbolize_names: true)
        
        expect(response.status).to eq(200)
        #expect()

    
    end
end