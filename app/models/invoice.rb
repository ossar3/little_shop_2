class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, counter_cache: true # :invoice_coupon_count, if: :coupon_id?, optional: true #automaticallly counts records for a model, basically automatically updates count of records
  has_many :transactions , dependent: :destroy
  has_many :invoice_items, dependent: :destroy

  validates :status, presence: true
end