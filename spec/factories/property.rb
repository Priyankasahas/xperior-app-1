FactoryGirl.define do
  factory :property do
    building_name Faker::Company.name
    address Faker::Address.street_address + Faker::Address.community +
            Faker::Address.state + Faker::Address.postcode
  end
end
