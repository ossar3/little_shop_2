class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :item_count, if: Proc.new { |_merchant, params| params && params[:sorted] == 'age' } do |merchant|
    merchant.items.size
  end
end
