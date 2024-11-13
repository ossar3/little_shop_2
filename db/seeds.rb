# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)


merchant = Merchant.create!(id: 499, name: "The Coin store")
puts "seed merchant: #{merchant.name}"

coupon1 = merchant.coupons.create!(id: 494, name: "BOGO50", code: "BOGO50", discount_value: 50, coupon_type: "percent")
coupon2 = merchant.coupons.create!(id: 495, name: "Discount3", code: "3BUCKS", discount_value: 3, coupon_type: "dollar")
coupon3 = merchant.coupons.create!(id: 496, name: "99%Off", code: "99percent", discount_value: 99, coupon_type: "percent")


invoice1 = merchant.invoices.create!(id: 3, customer_id: 3, coupon_id: coupon1.id, status: "shipped")
invoice2 = merchant.invoices.create!(id: 2, customer_id: 4, coupon_id: coupon2.id, status: "packaged")
invoice3 = merchant.invoices.create!(id: 1, customer_id: 5, coupon_id: nil, status: "shipped")



