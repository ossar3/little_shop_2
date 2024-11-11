class AddCouponTypeToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :coupon_type, :string
  end
end
