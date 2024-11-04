class Customer < ApplicationRecord
  has_many :invoices, dependent: :destroy
  # has_many :merchants, through: :invoices
  validates :first_name, :last_name, presence: true

  def self.show_all_customers(merchant_id)
    joins(:invoices).where("invoices.merchant_id = ?", merchant_id ).distinct
  end
end