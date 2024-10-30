require 'rails_helper'

RSpec.describe "Item endpoints", type: :request do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Test Merchant 2", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Test Merchant 3", created_at: 1.seconds.ago)

    @item_1 = Item.create!(name: "Precision Scale", description: "Weighs", unit_price:100.91 , merchant: @merchant_1)
    @item_2 = Item.create!(name: "Digital Thermometer", description: "Reads temperature", unit_price:300.23 , merchant: @merchant_2)
    @item_3 = Item.create!(name: "Silicone Baking Mat", description: "Non-stick magic", unit_price:20.23 , merchant: @merchant_3)
  end

  it "can retrieve ALL items" do
    get "/api/v1/items"

    expect(response.status).to eq(200)
    
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)

    items.each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      attributes = item[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end
  end

  it "can destroy items" do
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)
    
    delete "/api/v1/items/#{@item_2.id}"

    expect(response).to be_successful 
    expect(response.status).to eq(204)

    expect(items.count).to eq(2)
  end

end