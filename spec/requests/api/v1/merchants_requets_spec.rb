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
end