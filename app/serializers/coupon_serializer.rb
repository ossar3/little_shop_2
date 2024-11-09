class CouponSerializer
  include JSONAPI::Serializer
  attributes :name, :percent_off, :code
end
