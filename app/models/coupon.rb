class Coupon < ApplicationRecord
    belongs_to :merchant, counter_cache: true
    belongs_to :invoice, optional: true

    validates :name, presence: true
    validates :code, presence: true, uniqueness: true  
    validates :discount_value, presence: true
    validates :coupon_type, inclusion: { in: ["percent", "dollar"] }  # only allows percent or dollar for the coupon type
   
   

    validate :coupon_limit, on: [:create, :update]

    private 

    def coupon_limit
        if active && merchant.coupons.where(active: true).count >= 5
          errors.add(:base, "Merchants can have only 5 active coupons!")
        end
    end
end
    
