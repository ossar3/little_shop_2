class Coupon < ApplicationRecord
    belongs_to :merchant
    belongs_to :invoice, optional: true

    validates :name, presence: true
    validates :code, presence: true, uniqueness: true  # Ensure the coupon code is unique
    validates :discount_value, presence: true
    validates :coupon_type, inclusion: { in: ["percent", "dollar"] }  # Only allow percent or dollar for coupon type
    validate :validate_discount_value

    validate :coupon_limit, on: [:create, :update]

    private 

    def coupon_limit
        if active && merchant.coupons.where(active: true).count >= 5
          errors.add(:base, "Merchant can have a maximum of 5 active coupons")
        end
    end
end
    
