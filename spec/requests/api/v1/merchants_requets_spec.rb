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
end