class Api::V1::MerchantsCouponsController < ApplicationController
    
    def index
        coupons = Coupon.where(merchant_id: params[:merchant_id])
        render json: CouponSerializer.new(coupons)
    end
    
    def show
        coupon = Coupon.find(params[:id])
        render json: CouponSerializer.new(coupon)
    end
    
end