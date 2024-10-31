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

  it "returns merchants sorted by creation date (newest first)" do
    get "/api/v1/merchants?sorted=age"

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchants[0][:attributes][:name]).to eq("Test Merchant 3")
    expect(merchants[1][:attributes][:name]).to eq("Test Merchant 2")
    expect(merchants[2][:attributes][:name]).to eq("Test Merchant 1")
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

  it "includes item_count in the response when count=true" do
  
    Item.create!(name: "Item 1", description: "Description 1", unit_price: 10.0, merchant: @merchant_1)
    Item.create!(name: "Item 2", description: "Description 2", unit_price: 15.0, merchant: @merchant_1)
    Item.create!(name: "Item 3", description: "Description 3", unit_price: 20.0, merchant: @merchant_2)
  
    get "/api/v1/merchants?count=true"
  
    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
  
    expect(merchants[0][:attributes][:item_count]).to eq(2) 
    expect(merchants[1][:attributes][:item_count]).to eq(1) 
    expect(merchants[2][:attributes][:item_count]).to eq(0) 
  end

  it "returns only merchants that have invoices with status 'returned'" do
    customer = Customer.create!(first_name: "Gordon", last_name: "Ramsey")

    merchant_with_returned_invoice = Merchant.create!(name: "Merchant With Returned Invoice")
    merchant_without_returned_invoice = Merchant.create!(name: "Merchant Without Returned Invoice")
    another_merchant_with_returned_invoice = Merchant.create!(name: "Another Merchant With Returned Invoice")

    Invoice.create!(merchant: merchant_with_returned_invoice, customer: customer, status: "returned")
    Invoice.create!(merchant: merchant_without_returned_invoice, customer: customer, status: "shipped")
    Invoice.create!(merchant: another_merchant_with_returned_invoice, customer: customer, status: "returned")
    Invoice.create!(merchant: merchant_without_returned_invoice, customer: customer, status: "completed")

    get "/api/v1/merchants?status=returned"

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(2)
      
    returned_merchant_names = merchants.map { |merchant| merchant[:attributes][:name] }
    expect(returned_merchant_names).to contain_exactly("Merchant With Returned Invoice", "Another Merchant With Returned Invoice")
  end
end