require 'faker'

FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Finance.credit_card(:visa).delete('-') }
    credit_card_expiration_date { "12/24" }
    association :invoice
  end
end
