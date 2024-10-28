class InvoiceItem < ApplicationRecord
 belongs_to :items
 belongs_to :invoices
end