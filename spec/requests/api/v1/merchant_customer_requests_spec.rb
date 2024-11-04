require 'rails_helper'

RSpec.describe "Merchants customer endpoints", type: :request do
  before(:each) do 
   @merchant1 = Merchant.create(name: "Test Merchant 1", created_at: 3.seconds.ago)
   @merchant2 = Merchant.create(name: "Test Merchant 2", created_at: 2.seconds.ago)
   @merchant3 = Merchant.create(name: "Test Merchant 3", created_at: 1.second.ago)

   @customer_1 = Customer.create(first_name: "Abby", last_name: "Bronson")
   @customer_2 = Customer.create(first_name: "Catherine", last_name: "Deitch")
   @customer_3 = Customer.create(first_name: "Edgar", last_name: "Flores")
   @customer_4 = Customer.create(first_name: "Gordan", last_name: "Herrowits")

   @invoice_1 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant1[:id]), status: "returned")
   @invoice_2 = Invoice.create(customer_id: (@customer_3[:id]) , merchant_id: (@merchant2[:id]), status: "returned")
   @invoice_3 = Invoice.create(customer_id: (@customer_4[:id]) , merchant_id: (@merchant3[:id]), status: "returned")
   @invoice_4 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant1[:id]), status: "returned")
   @invoice_4 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant2[:id]), status: "returned")
 
  end

  it "can send requests and recieve a response" do
    get "/api/v1/merchants/#{@merchant1.id}/customers"
    result_1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(200)
    get "/api/v1/merchants/#{@merchant2.id}/customers"
    expect(response).to have_http_status(200)
    result_2 = JSON.parse(response.body, symbolize_names: true)

    expect(result_1[:data][0][:id]).to eq((@customer_1[:id]).to_s)
    expect(result_2[:data][0][:id]).to eq((@customer_1[:id]).to_s)
    expect(result_2[:data][1][:id]).to eq((@customer_3[:id]).to_s)
  end 

  it "can send request and recieve a response sad path" do
    
  end
endrequire 'rails_helper'

RSpec.describe "Merchants customer endpoints", type: :request do
  before(:each) do 
   @merchant1 = Merchant.create(name: "Test Merchant 1", created_at: 3.seconds.ago)
   @merchant2 = Merchant.create(name: "Test Merchant 2", created_at: 2.seconds.ago)
   @merchant3 = Merchant.create(name: "Test Merchant 3", created_at: 1.second.ago)

   @customer_1 = Customer.create(first_name: "Abby", last_name: "Bronson")
   @customer_2 = Customer.create(first_name: "Catherine", last_name: "Deitch")
   @customer_3 = Customer.create(first_name: "Edgar", last_name: "Flores")
   @customer_4 = Customer.create(first_name: "Gordan", last_name: "Herrowits")

   @invoice_1 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant1[:id]), status: "returned")
   @invoice_2 = Invoice.create(customer_id: (@customer_3[:id]) , merchant_id: (@merchant2[:id]), status: "returned")
   @invoice_3 = Invoice.create(customer_id: (@customer_4[:id]) , merchant_id: (@merchant3[:id]), status: "returned")
   @invoice_4 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant1[:id]), status: "returned")
   @invoice_4 = Invoice.create(customer_id: (@customer_1[:id]) , merchant_id: (@merchant2[:id]), status: "returned")
 
  end

  it "can send requests and recieve a response" do
    get "/api/v1/merchants/#{@merchant1.id}/customers"
    result_1 = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(200)
    get "/api/v1/merchants/#{@merchant2.id}/customers"
    expect(response).to have_http_status(200)
    result_2 = JSON.parse(response.body, symbolize_names: true)

    expect(result_1[:data][0][:id]).to eq((@customer_1[:id]).to_s)
    expect(result_2[:data][0][:id]).to eq((@customer_1[:id]).to_s)
    expect(result_2[:data][1][:id]).to eq((@customer_3[:id]).to_s)
  end 

  it "can send request and recieve a response sad path" do
      get "/api/v1/merchants/145890000/customers"
      expect(response).to have_http_status(404)
      get "/api/v1/merchants/-145890000/customers"
      expect(response).to have_http_status(404)
  end
end