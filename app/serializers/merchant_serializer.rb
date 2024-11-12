class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  attribute :item_count, if: Proc.new { |merchant, params| params[:count] == 'true' && merchant.respond_to?(:item_count) }
  attribute :created_at, if: Proc.new { |_, params| params[:sorted] == 'age' }

  # attribute :coupons_count, if: Proc.new { |merchant, params| params[:count] == 'true' && merchant.respond_to?(:coupons_count) }

  # attribute :invoice_coupon_count, if: Proc.new { |_, params| params[:count] == 'true' } do |merchant|
  #   merchant.invoices.where.not(coupon_id: nil).count
  attribute :coupons_count do |merchant|
    merchant.coupons_count
  end

  attribute :invoice_coupon_count do |merchant|
    merchant.invoice_coupon_count
  end
  

end
