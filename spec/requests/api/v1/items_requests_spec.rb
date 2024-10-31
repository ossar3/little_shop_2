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
    items = Item.all
    expect(items.count).to eq(3)
    
    delete "/api/v1/items/#{@item_2.id}"

    expect(response).to be_successful 
    expect(response.status).to eq(204)

    expect(items.count).to eq(2)
  end

  it "can create new items" do 
    attributes = {
      name: "chocolate bar",
      description: "sweet and delicious",
      unit_price: 3.99,
      merchant_id: 1
    }

    post "/api/v1/items", params:{item: attributes}

    item_new = JSON.parse(response.body, symbolize_names: true)

    id = item_new[:data][:id]

    get "/api/v1/items"

    all_items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(item_new[:data][:attributes][:name]).to eq("chocolate bar")
    
  end
  
  it "can retrieve a single item by id" do
    id = @item_1.id
    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)
   
    expect(response.status).to eq(200)
    expect(item).to have_key(:data)
 
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_a(String)

    expect(item[:data]).to have_key(:attributes)
    attributes = item[:data][:attributes]
    
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(Float)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_a(Integer)
  end

  it "can update an item by id" do
    previous_item = @item_1
    item_params = { name: "Test", description: "is successful", unit_price: 9.99, merchant_id: @merchant_2.id}
    headers = { "CONTENT_TYPE" => "application/json" }

    put "/api/v1/items/#{@item_1.id}", headers: headers, params: JSON.generate({ item: item_params })

    changed_item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(changed_item[:data][:attributes][:name]).to eq("Test")
    expect(changed_item[:data][:attributes][:description]).to eq("is successful")
    expect(changed_item[:data][:attributes][:unit_price]).to eq(9.99)
    expect(changed_item[:data][:attributes][:merchant_id]).to eq(@merchant_2.id)
  end

  it "returns all items by price(low to high)" do 
    
    get "/api/v1/items?sorted=price" 

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    prices = items.map { |item| item[:attributes][:unit_price] }
    expect(prices).to eq(prices.sort)

  end
end