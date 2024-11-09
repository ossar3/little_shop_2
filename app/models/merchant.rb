class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :coupons, optional: true

  validates :name, presence: true

  def self.fetch_merchants(params)
    merchants = sort_and_filter(params)
    merchants = merchants_with_item_counts(merchants) if params[:count] == 'true'
    merchants
  end

  def self.sort_and_filter(params)
    if params[:status] == "returned"
      merchants_with_returns
    elsif params[:sorted] == "age"
      sort
    else
      all
    end
  end

  def self.merchants_with_item_counts(merchants)
    merchants.map do |merchant|
      merchant.define_singleton_method(:item_count) { merchant.items.size }
      merchant
    end
  end

  def self.sort
    order(created_at: :desc)
  end

  def self.merchants_with_returns
    joins(:invoices).where(invoices: { status: "returned" }).distinct
  end
  
  def item_count 
    self.items.count
  end

  def self.find_one_by_name(params)
    name_input = params[:name]
    where("name ILIKE ?", "%#{name_input}%").order("LOWER(name)").first
  end
end