require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Associations' do
    it { should belong_to(:merchant) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
  end

  describe "Item Class Methods" do 
    before(:each) do
      @merchant = Merchant.create!(name: "Test Merchant")

      @item_1 = Item.create!(name: "Precision Scale", description: "Weighs", unit_price:100.91 , merchant: @merchant)
      @item_2 = Item.create!(name: "Digital Thermometer", description: "Reads temperature", unit_price:420.23 , merchant: @merchant)
      @item_3 = Item.create!(name: "Silicone Baking Mat", description: "Non-stick magic", unit_price:10.23 , merchant: @merchant)
      @item_4 = Item.create!(name: "Apron", description: "Keeps us clean", unit_price: 120.99, merchant: @merchant)
    end

    it "returns all items sorted by price (low to high)" do 
      expected = [@item_3, @item_1, @item_4, @item_2]
      expect(Item.sorted_by_price).to eq(expected)
    end
  end

  it "returns an empty array when no items are present" do 
    Item.delete_all
    expect(Item.sorted_by_price).to eq([])
    end

  it "is invalid without a merchant" do
    item = Item.new(name: "No Merchant Item", description: "Has no merchant", unit_price: 50)
    expect(item).to_not be_valid
    expect(item.errors[:merchant]).to include("must exist")
  end
end