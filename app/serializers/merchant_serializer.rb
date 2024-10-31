class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  attribute :item_count, if: Proc.new { |_, params| params && params[:count] == 'true' }
  attribute :created_at, if: Proc.new { |_, params| params && params[:sorted] == 'true' }

end
