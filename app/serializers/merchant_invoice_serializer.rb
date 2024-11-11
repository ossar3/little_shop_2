class MerchantInvoiceSerializer
    include JSONAPI::Serializer
    attributes :customer_id, :merchant_id, :coupon_id, :status
end