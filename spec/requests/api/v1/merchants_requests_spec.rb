require 'rails_helper'

RSpec.describe "Merchants endpoints", type: :request do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Test Merchant 2", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Test Merchant 3", created_at: 1.seconds.ago)    
  end

  it "can retrieve ALL merchants" do
    get "/api/v1/merchants"
    
    expect(response.status).to eq(200)
    
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  it "can destroy merchant" do
    merchants = Merchant.all
    expect(merchants.count).to eq(3)
    
    
    delete "/api/v1/merchants/#{@merchant_2.id}"

    expect(response).to be_successful 
    expect(response.status).to eq(204)

    expect(merchants.count).to eq(2)
  end
  
  it "can create new merchants" do 
    attributes = {
      name: "the chocolate bar guy",
    }

    post "/api/v1/merchants", params:{merchant: attributes}

    merchant_new = JSON.parse(response.body, symbolize_names: true)

    id = merchant_new[:data]

    get "/api/v1/merchants"

    all_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(merchant_new[:data][:attributes][:name]).to eq("the chocolate bar guy")
    expect(all_merchants[:data]).to include(id)

  end
  
  it "can retrieve a single merchant by id" do
    id = @merchant_1.id
    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
   
    expect(response.status).to eq(200)
    expect(merchant).to have_key(:data)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)

    expect(merchant[:data]).to have_key(:attributes)
    attributes = merchant[:data][:attributes]

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

  end
  it "can update a merchant by id" do
    previous_name = @merchant_1.name
    merchant_params = { name: "Billy" }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/merchants/#{@merchant_1.id}", headers: headers, params: JSON.generate({ merchant: merchant_params })
    
    changed_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(changed_merchant[:data][:attributes][:name]).to_not eq(previous_name)
    expect(changed_merchant[:data][:attributes][:name]).to eq("Billy")
  end

end