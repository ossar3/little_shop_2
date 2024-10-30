class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy

  validates :name, presence: true

  def self.fetch_merchants(params)
    if params[:sorted] == 'age'
      order(created_at: :desc)
    else
      all
    end
  end
end