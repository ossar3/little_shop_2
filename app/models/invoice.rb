class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :transactions , dependent: :destroy
  has_many :invoice_items, dependent: :destroy

  validates :status, presence: true
end