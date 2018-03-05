require 'factory_bot'

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password 'password'
    factory :admin do
      # admin true
    end
  end
end
