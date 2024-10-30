class Invoice < ApplicationRecord
  belongs_to :customers
  belongs_to :merchants
  has_many :transactions , dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  #deletes from parent to child records, needed in this case for delete method
end