require 'rails_helper'

RSpec.describe "Item_merchants", type: :request do
    before(:each) do
        @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)

        @item_1 = Item.create!(name: "Precision Scale", description: "Weighs", unit_price:100.91 , merchant: @merchant_1)
    end

    it "can give the merchant of a selected item" do
     
        id = @item_1[:id]
        item_merchant = @item_1.merchant_id

        get "/api/v1/items/#{id}/merchant"

        merchant = JSON.parse(response.body,symbolize_names: true)
     
        expect(response.status).to eq(200)
        expect(merchant[:data][:id]).to eq(item_merchant.to_s)
    end
end