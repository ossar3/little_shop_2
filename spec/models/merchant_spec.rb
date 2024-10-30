require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'Associations' do
    it { should have_many(:items) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
  end

  describe '.fetch_merchants' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Test Merchant 1", created_at: 3.seconds.ago)
      @merchant_2 = Merchant.create!(name: "Test Merchant 1", created_at: 2.seconds.ago)
      @merchant_3 = Merchant.create!(name: "Test Merchant 3", created_at: 1.second.ago)
    end

    it "returns all merchants when no sorted parameter is provided" do
      result = Merchant.fetch_merchants({})

      expect(result.count).to eq(3)
      expect(result).to contain_exactly(@merchant_1, @merchant_2, @merchant_3)
    end

    it "returns merchants sorted by age when sorted=age is provided" do
      result = Merchant.fetch_merchants({ sorted: 'age' })

      expect(result.count).to eq(3)
      expect(result.first).to eq(@merchant_3) 
      expect(result.last).to eq(@merchant_1)  
    end
  end
end