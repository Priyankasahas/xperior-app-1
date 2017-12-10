FactoryGirl.define do
  factory :user do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email do
      "#{first_name}.#{last_name}-#{Faker::Number.number(10)}@#{Faker::Company.name.parameterize}.#{Faker::Internet.domain_suffix}".downcase
    end
    password '123Qwerty'
    password_confirmation '123Qwerty'
    authentication_token 'GKKOAlHPQrbIHYaJ'
    authentication_token_created_at Time.now
  end
end
