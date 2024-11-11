class Api::V1::MerchantsCouponsController < ApplicationController
    
  
    def index
      coupons = Coupon.where(merchant_id: params[:merchant_id])

      if params[:active].present?
        active_status = params[:active] == 'true' #if the value queried == 'true' then true if false then you will get the inactive coupons
        coupons = coupons.where(active: active_status)
      end
      
      render json: CouponSerializer.new(coupons)
    end
  
    def show
        coupon = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])
      render json: CouponSerializer.new(coupon)
    end
  
    def create
        #binding.pry
        merchant = Merchant.find(params[:merchant_id])
      coupon = merchant.coupons.create!(coupon_params)
      if coupon.save
        render json: CouponSerializer.new(coupon), status: :created
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def activate
        coupon = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])
      if coupon.update(active: true)
        render json: CouponSerializer.new(coupon)
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def deactivate
        coupon = Coupon.find_by(id: params[:id], merchant_id: params[:merchant_id])
      if coupon.update(active: false)
        render json: CouponSerializer.new(coupon)
      else
        render json: { errors: coupon.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    # parameters for coupon creation
    def coupon_params
      params.require(:coupon).permit(:name, :code, :discount_value, :active, :coupon_type)
    end
end
  